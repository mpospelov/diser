require_relative '../models/solution'

class SolutionFinderService
  def initialize(customers, vehicle_count)
    @customers = customers
    @vehicle_count = vehicle_count
  end

  def genetic_algorithm
    fitness = ->(solution) do
      solution.total_distance + 1 * solution.over_capacity + 1 * solution.total_over_time
    end
    solutions = []
    population_size = (@customers.count * 0.1).to_i
    population_size.times do
      routes = []
      @customers.shuffle.each_slice(@customers.count / @vehicle_count).with_index do |customers|
        routes << Route.new(customers: customers.sort_by(&:time1))
      end
      solutions << Solution.new(routes: routes)
    end
    first_population = Population.new(solutions: solutions)
    first_population.print_fitness_values(fitness)
    solution = GeneticAlgorithm.new(fitness, first_population, population_size).find_solution
    file = File.open('output/out.json','w') { |f| f.write(solution.to_json) }
  end
end
