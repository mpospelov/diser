module VRP
  class Route
    include Virtus.model

    attribute :customers, Array[Customer]

    def distance
      TSP::TravellingSalesmanProblem.new(customers.map(&:id)).solve
    end

    def old_distance
      @distance ||= begin
        current_position = nil
        result = 0
        customers.each do |customer|
          if current_position.nil?
            current_position = customer.position
            next
          end

          distance = distance_between(current_position, customer.position)
          # puts "POSITION: #{current_position}"
          # puts "DISTANCE: #{distance}"
          # puts "RESULT: #{result}"
          result += distance
          current_position = customer.position
        end
        result
      end
      # puts "ROUTE DISTANCE: #{@distance}"
      @distance
    end

    def over_time
      @over_time ||= begin
        current_position = nil
        result = 0
        current_time = 0
        customers.each do |customer|
          if current_position.nil?
            current_position = customer.position
            next
          end
          distance = distance_between(current_position, customer.position)
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
end
