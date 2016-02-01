require_relative '../models/solution'

class SolutionFinderService
  def initialize(customers, vehicle_count)
    @customers = customers
    @vehicle_count = vehicle_count
  end

  def genetic_algorithm
    f = ->(solution) do
      solution.total_distance + 1 * solution.over_capacity + 1 * solution.over_time
    end

    fitness = ->(solution, fitness_max) do
      fitness_max - f(solution)
    end
    routes = []
    first_population = []
    population_size = (@customers.count * 0.1).to_i
    population_size.times do
      @customers.shuffle.each_slice(@customers.count / @vehicle_count).with_index do |customers, id|
        routes << Solution::Route.new(vehicle_id: id + 1, customers: customers.sort_by(&:time1))
      end
      first_population << Solution.new(routes: routes)
    end
    GeneticAlgorithm.new(fitness, first_population, population_size).find_solution
  end
end
