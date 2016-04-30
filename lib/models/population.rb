require_relative 'solution'
module VRP
  class Population
    @@index = 0
    include Virtus.model

    class FitnessResult
      include Virtus.model

      attribute :max, Float
      attribute :fitness_value, Hash
      attribute :total_fitness
    end

    attribute :solutions, Array[Solution]

    def initialize(*)
      super
      @id = @@index
      @@index += 1
    end

    def new_population(fitness_fn, size)
      err, parents = calc_parents(fitness_fn, size)
      if err
        [true, nil]
      else
        [false, Population.new(solutions: merge(parents))]
      end
    end

    def print_fitness_values(fitness)
      result = solutions.map { |s| fitness.call(s) }
      puts result.to_s
    end

    private

    def merge(parents)
      parents.map do |(par1, par2)|
        new_solution_routes = []
        route1 = par1.routes.first
        new_solution_routes << route1
        (par2.routes | par1.routes).each do |p_route|
          already_in_sol = new_solution_routes.any? { |r| !(r.customers & p_route.customers).empty? }
          next if already_in_sol
          new_solution_routes << p_route
        end
        Solution.new(routes: new_solution_routes)
      end
    end

    def calc_parents(fitness_fn, size)
      val = calc_fitness(fitness_fn)
      # return [true, []] if val.total_fitness == 0 # Stagnation
      result = []
      left_border = 0
      probability_ranges = val.fitness_value.map do |solution, values|
        probability = values[:probability]
        right_border = left_border + probability
        range = (left_border...right_border)
        left_border = right_border
        [range, solution]
      end
      size.times do
        roulette1 = rand
        first_parent = probability_ranges.detect { |(range, _)| range.include?(roulette1) }
        second_parent = nil
        while !second_parent
          roulette2 = rand
          second_parent = probability_ranges.detect do |(range, parent)|
            range.include?(roulette2) && parent != first_parent
          end
        end
        result << [first_parent[1], second_parent[1]]
      end
      [false, result]
    end

    def calc_fitness(fitness_fn)
      @fitness_store ||= {}
      @fitness_store[fitness_fn.object_id] ||= begin
        max = -1_000_000
        fitness_value = {}
        solutions.each do |solution|
          fit_val = fitness_fn.call(solution)
          fit_value_for_store = fit_val.finite? ? fit_val : INFINITY
          fitness_value[solution] = { value: fit_value_for_store }
          max = fit_value_for_store if fit_value_for_store > max
        end
        total_fitness = solutions.inject(0) { |acc, s| acc += max - fitness_value[s][:value] }
        solutions.each do |solution|
          fit_val_store = fitness_value[solution]
          # NOTE: if no difference between solution every has same chances
          fit_val_store[:probability] = if total_fitness.zero?
            1.fdiv(solutions.count)
          else
            (max - fit_val_store[:value]) / total_fitness
          end
        end
        FitnessResult.new(max: max, fitness_value: fitness_value, total_fitness: total_fitness)
      end
    end
  end
end
