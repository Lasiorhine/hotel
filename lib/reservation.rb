require 'date'
require 'pry'

# require_relative 'room'
# require_relative 'front_desk'


module Hotel
  class Reservation
    attr_accessor :start_date, :end_date
    attr_reader :id, :total_nights, :total_reservation_cost

    @@last_id_base = 0

    # The constant below, MIN_RES_IN_SEC, is the length of the minimum reservation, in seconds.  This figure was arrived at by calculating the number of seconds between an early-but-common check-out time (10:00 am) and the change of date at midnight.  The putative customer could, of course, change this to whatever they wanted.
    MIN_RES_IN_SEC = 36000

    #Since all rooms are identical, and we haven't been given any parameters for price variation, it makes sense to assign a default price for the moment.  If the customer needs more options or granularity here, that cna be implemented later
    PER_NIGHT_PRICE = 100.00

    def initialize(start_date, end_date)
      @id = assign_id
      @start_date = DateTime.parse(start_date)
      @end_date = DateTime.parse(end_date)
      @total_nights = calculate_total_nights
      @total_reservation_cost = calculate_reservation_price


      if (@start_date.to_time.to_i - @end_date.to_time.to_i) > MIN_RES_IN_SEC || @start_date.to_time.to_i < Time.now.to_i
        raise StandardError.new("A reservation's end date must come after its start date, and it must be at least one night long.")
      end
    end

    def assign_id
      new_id_base = (@@last_id_base + 1).to_s
      @@last_id_base += 1
      zeroes_needed = 8 - new_id_base.length
      leading_zero_array = (1..zeroes_needed).collect {"0"}
      new_id = leading_zero_array.join.concat(new_id_base)
      return new_id
    end

    def calculate_total_nights
      (@start_date.to_date - @end_date.to_date).to_i
    end

    def calculate_reservation_price
      (@total_nights * PER_NIGHT_PRICE).round(2)
    end
  end
end
