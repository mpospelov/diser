require_relative 'customer'
require_relative 'route'
require 'json'

class Solution
  include Virtus.model

  attribute :routes, Array[Route]

  def total_distance
    @total_distance ||= routes.inject(0) { |acc, route| acc += route.distance }
  end

  def over_capacity
    0
  end

  def total_over_time
    @over_time ||= routes.inject(0) { |acc, route| acc += route.over_time }
  end

  def to_json
    routes.map do |route|
      route.customers.map(&:position)
    end.to_json
  end
end
