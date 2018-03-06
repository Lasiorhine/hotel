require 'date'
require 'pry'

# require_relative 'room'
# require_relative 'front_desk'


module Hotel
  class Reservation
    attr_accessor :id, :start_date, :end_date

    @@last_id_base = 0

    #36000 seconds is ten hours. This figure was arrived at by taking the most likely check-out time (10:00 am) and determining the number of seconds since the change of date at midnight. The putative customer could change this easily, depending on their needs.
    MIN_RES_IN_SEC = 36000

    def initialize(start_date, end_date)
      @id = assign_id
      @start_date = DateTime.parse(start_date)
      @end_date = DateTime.parse(end_date)

      if (@start_date.to_time.to_i - @end_date.to_time.to_i) > MIN_RES_IN_SEC || @start_date.to_time.to_i < Time.now.to_i
        raise StandardError.new("A reservation's end date must come after its start date.")
      end
    end

    # def calculate_cumulative_price
    # end

    def assign_id
      new_id_base = (@@last_id_base + 1).to_s
      @@last_id_base += 1
      zeroes_needed = 8 - new_id_base.length
      leading_zero_array = (1..zeroes_needed).collect {"0"}
      new_id = leading_zero_array.join.concat(new_id_base)
      return new_id
    end
  end
end
