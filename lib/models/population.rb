require_relative 'solution'

class Population
  include Virtus.model

  attribute :solutions, Array[Solution]

  def print_fitness_values(fitness)
    puts solutions.map { |s| fitness.call(s, 0) }.to_s
  end
end
