class GeneticAlgorithm
  MAX_ITERATION_COUNT = 1_000_000

  def initialize(fitness_fn, first_population, population_size)
    @fitness_fn = fitness_fn
    @current_population = first_population
    @population_size = population_size
    @max_fitness = -1_000_000_000 # -Infinity
  end

  def find_solution
    @solution ||= begin
      i = 0
      result = @first_population
      while MAX_ITERATION_COUNT > i
        @current_population.print_fitness_values(@fitness_fn)
        result = @current_population
        err, @current_population = @current_population.new_population(@fitness_fn, @population_size)
        break if err
        i += 1
      end
      result.solutions[0]
    end
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
