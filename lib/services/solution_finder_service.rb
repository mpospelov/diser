require_relative '../models/solution'
module VRP
  class SolutionFinderService
    def initialize(customers, vehicle_count)
      @customers = customers
      @vehicle_count = vehicle_count
    end

    def genetic_algorithm
      fitness = ->(solution) do
        solution.total_distance + 1 * solution.over_capacity + 1 * solution.total_over_time
      end

      ga_service = VRP::GeneticAlgorithm.new(fitness, (@customers.count * 100).to_i, @customers, @vehicle_count)
      ga_service.generate_random_population
      solution = ga_service.find_solution
      debugger
      file = File.open('output/out.json','w') { |f| f.write(solution.to_json) }
    end
  end
end
