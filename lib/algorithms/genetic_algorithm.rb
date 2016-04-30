module VRP
  class GeneticAlgorithm
    MAX_ITERATION_COUNT = 10
    MAX_ERRORS_COUNT = 100

    def initialize(fitness_fn, population_size, customers, vehicle_count)
      @customers = customers
      @vehicle_count = vehicle_count
      @fitness_fn = fitness_fn
      @population_size = population_size
      @max_fitness = -1_000_000_000 # -Infinity
    end

    def find_solution
      @solution ||= begin
        i = 0
        err_count = 0
        result = @first_population
        while MAX_ITERATION_COUNT > i && MAX_ERRORS_COUNT > err_count
          @current_population.print_fitness_values(@fitness_fn)
          result = @current_population
          err, @current_population = @current_population.new_population(@fitness_fn, @population_size)
          if err
            err_count += 1
            generate_random_population
          end
          i += 1
        end
        result.solutions[0]
      end
    end

    def generate_random_population
      solutions = []
      @population_size.times do
        routes = []
        @customers.shuffle.each_slice(@customers.count / @vehicle_count).with_index do |customers|
          routes << VRP::Route.new(customers: customers)
        end
        solutions << VRP::Solution.new(routes: routes)
      end
      @current_population = VRP::Population.new(solutions: solutions)
      @current_population.print_fitness_values(@fitness_fn)
    end

    private

    def calc_fintess(solution)
      @fitness_store ||= {}
      @fitness_store[solution.object_id] ||= begin
        result = fitness_fn.call(solution)
        @max_fitness = result if @max_fitness < result
        result
      end
    end

    def select_parents(population)

    end
  end
end
