require_relative '../models/solution'

class SolutionFinderService
  def initialize(customers, vehicle_count)
    @customers = customers
    @vehicle_count = vehicle_count
  end

  def genetic_algorithm
    fitness = ->(solution, fitness_max) do
      fitness_max - (solution.total_distance + 1 * solution.over_capacity + 1 * solution.total_over_time)
    end
    solutions = []
    population_size = (@customers.count * 0.1).to_i
    population_size.times do
      routes = []
      @customers.shuffle.each_slice(@customers.count / @vehicle_count).with_index do |customers, id|
        routes << Route.new(vehicle_id: id + 1, customers: customers.sort_by(&:time1))
      end
      solutions << Solution.new(routes: routes)
    end
    first_population = Population.new(solutions: solutions)
    first_population.print_fitness_values(fitness)
    GeneticAlgorithm.new(fitness, first_population, population_size).find_solution
  end
end
