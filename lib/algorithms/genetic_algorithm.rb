class GeneticAlgorithm
  def initialize(fitness_fn, first_population, population_size)
    @fitness_fn = fitness_fn
    @first_population = first_population
    @population_size = population_size
  end

  def find_solution
  end

  private

  def calc_fintess(solution)
    @fitness_store ||= {}
    @fitness_store[solution.object_id] ||= begin
      fitness_fn.call(solution)
    end
  end
end
