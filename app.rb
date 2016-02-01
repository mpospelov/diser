require 'bundler'

Bundler.require(:default)
app_files = Dir['lib/**/*.rb']
app_files.each { |f| require_relative f }

customer_parser = CustomerParserService.new(File.join(Dir.pwd, 'data/rc101.csv'))

solution = SolutionFinderService.new(customer_parser.parse, 5)
solution.genetic_algorithm
puts 'a'
