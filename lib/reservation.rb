require 'date'

# require_relative 'room'
# require_relative 'front_desk'

module Hotel
  class Reservation
    attr_accessor :id, :start_date, :end_date

    @@last_id_base = 0

    def initialize(start_date, end_date)
      @id = assign_id
      @start_date = DateTime.parse(start_date)
      @end_date = DateTime.parse(end_date)
    end

    def calculate_cumulative_price
    end

    def assign_id
      new_id_base = (@@last_id_base + 1).to_s
      @@last_id_base += 1
      zeroes_needed = 8 - new_id_base.length
      leading_zero_array = []
      zeroes_needed.times do
        leading_zero_array << "0"
      end
      leading_zero_block = leading_zero_array.join
      new_id = leading_zero_block.concat(new_id_base)
      return new_id
    end
  end
end
