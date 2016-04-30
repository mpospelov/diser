require 'bundler'
APP_PATH = Dir.pwd.freeze

Bundler.require(:default)
require_relative './lib/vrp'
require_relative './tsp_diser/V_1/lib/tsp'

customer_parser = VRP::CustomerParserService.new(File.join(Dir.pwd, 'data/rc101.csv'))

solution = VRP::SolutionFinderService.new(customer_parser.parse, 2)
solution.genetic_algorithm
puts 'a'
