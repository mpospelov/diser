class GeneticAlgorithm
  def initialize(fitness_fn, first_population, population_size)
    @fitness_fn = fitness_fn
    @first_population = first_population
    @population_size = population_size
    @max_fitness = -1_000_000_000 # -Infinity
  end

  def find_solution
  end

  private

  def calc_fintess(solution)
    @fitness_store ||= {}
    @fitness_store[solution.object_id] ||= begin
      result = fitness_fn.call(solution, @max_fitness)
      @max_fitness = result if @max_fitness < result
      result
    end
  end
end
