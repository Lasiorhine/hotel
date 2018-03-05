require 'date'

# require_relative 'room'
# require_relative 'front_desk'

module Hotel
  class Reservation
    attr_accessor :id, :start_date, :end_date

    def initialize(start_date, end_date)
      @id = :id
      @start_date = start_date
      @end_date = end_date
    end

    def calculate_cumulative_price
    end
  end
end
