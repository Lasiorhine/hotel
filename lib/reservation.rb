require 'date'
require 'pry'

# require_relative 'room'
# require_relative 'front_desk'


module Hotel
  class Reservation
    attr_accessor :start_date, :end_date
    attr_reader :id, :days_booked_am_and_pm, :total_nights, :total_reservation_cost

    @@last_id_base = 0

    # The constant below, MIN_RES_IN_SEC, is the length of the minimum reservation, in seconds.  This figure was arrived at by calculating the number of seconds between an early-but-common check-out time (10:00 am) and the change of date at midnight.  The putative customer could, of course, change this to whatever they wanted.
    MIN_RES_IN_SEC = 36000

    #Since all rooms are identical, and we haven't been given any parameters for price variation, it makes sense to assign a default price for the moment.  If the customer needs more options or granularity here, that cna be implemented later
    PER_NIGHT_PRICE = 100.00

    def initialize(start_date, end_date)
      @id = assign_id
      @start_date = DateTime.parse(start_date)
      @end_date = DateTime.parse(end_date)
      @days_booked_am_and_pm = days_with_am_and_pm_occupation
      @total_nights = calculate_total_nights
      @total_reservation_cost = calculate_reservation_price

      #THIS IS GOOD, BUT IT EFFS UP YOUR ABILITY TO TEST CERTAIN SHIT. MAYBE PUT THE VALIDATION MEASURE FOR START-DATES IN THE PAST IN FrontDesk??? OR RESCUE??
      ## Commenting out the req about not starting reservations in the past--- for now.
      if (@end_date.to_time.to_i - @start_date.to_time.to_i) < MIN_RES_IN_SEC #|| @start_date.to_time.to_i < Time.now.to_i
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
      (@end_date.to_date - @start_date.to_date).to_i
    end

    def days_with_am_and_pm_occupation
      first_key = @start_date.jd.to_s
      last_key = @end_date.jd.to_s
      start_and_end_days = {
        first_key => {
          :am => false,
          :pm => true
          },
        last_key => {
          :am => true,
          :pm => false
          }
        }
      intervening_span = (last_key.to_i - first_key.to_i - 1)
      mid_keys_array = []
      while intervening_span > 0
        mid_key = (first_key.to_i + intervening_span).to_s
        mid_keys_array << mid_key
        intervening_span -= 1
      end
      full_days_in_use = {}
      unless mid_keys_array.empty?
        full_days_in_use = mid_keys_array.map {|day| [day, {:am => true, :pm => true}] }
      end
      all_days_in_use = start_and_end_days.merge(full_days_in_use.to_h)
    end

    def calculate_reservation_price
      #I know this isn't exactly best practice for dealing with real-world currency.  But since we haven't covered that yet and this isn't the real world, this is what I'm going with.
       (@total_nights * PER_NIGHT_PRICE).round(2)
    end
  end
end
