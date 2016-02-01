require_relative 'customer'
require_relative 'constants'

class Solution
  include Virtus.model

  class Route
    include Virtus.model

    attribute :vehicle_id, Integer
    attribute :customers, Array[Customer]
  end

  attribute :routes, Array[Route]

  def total_distance
    @total_distance ||= begin
      current_position = nil
      result = 0
      customers.each do |customer|
        if current_position.nil?
          current_position = [customer.x, customer.y]
          next
        end
        result += distance_between(current_position, [customer.x, customer.y])
      end
      result
    end
  end

  def over_capacity
    0
  end

  def over_time
    @over_time ||= begin
      result = 0
      current_time = 0
      customers.each do |customer|
        if current_position.nil?
          current_position = [customer.x, customer.y]
          next
        end
        distance = distance_between(current_position, [customer.x, customer.y])
        current_time += distance / speed
        if current_time < customer.time1
          wait = customer.time1 - current_time
          result += wait
          current_time += wait
        end
        current_time += customer.service_time
      end
      result
    end
  end

  private

  def distance_between(x, y)
    Math.sqrt((x[1] - x[0])**2 + (y[1] - y[0])**2)
  end

  def speed
    1
  end
end
