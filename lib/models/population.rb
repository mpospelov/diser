require_relative 'solution'

class Population
  @@index = 0
  include Virtus.model

  class FitnessResult
    include Virtus.model

    attribute :max, Integer
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
    file = PlotService.create_plot_file(result)
    PlotService.new('bar_plot', file, "output/random/#{@id}population.png").call
  end

  private

  def merge(parents)
    parents.map do |(par1, par2)|
      separate_point = rand([par1.routes.size, par2.routes.size].max)

      left_part = par1.routes[0..separate_point]
      right_part = par2.routes[(separate_point + 1)..-1]
      Solution.new(routes: left_part | right_part)
    end
  end

  def calc_parents(fitness_fn, size)
    val = calc_fitness(fitness_fn)
    return [true, []] if val.total_fitness == 0 # Stagnation
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
        fitness_value[solution] = { value: fit_val }
        max = fit_val if fit_val > max
      end

      total_fitness = solutions.inject(0) { |acc, s| acc += max - fitness_value[s][:value] }
      solutions.each do |solution|
        fit_val_store = fitness_value[solution]
        fit_val_store[:probability] = (max - fit_val_store[:value]) / total_fitness
      end
      FitnessResult.new(max: max, fitness_value: fitness_value, total_fitness: total_fitness)
    end
  end
end
