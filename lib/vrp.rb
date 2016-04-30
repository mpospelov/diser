require_relative './algorithms/genetic_algorithm'
require_relative './models/customer'
require_relative './models/population'
require_relative './models/route'
require_relative './models/solution'
require_relative './services/customer_parser_service'
require_relative './services/plot_service'
require_relative './services/solution_finder_service'

module VRP
  INFINITY = 1_000_000_000_000
  START_DEPOT_POSITION = [0, 0].freeze
end
