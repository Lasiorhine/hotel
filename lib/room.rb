require 'date'

require_relative 'reservation'
require_relative 'front_desk'

module Hotel
  class Room
    attr_accessor :room_number, :reservations, :dates_unavailable

    def initialize(room_number)
      @room_number = room_number
      @reservations = []
      @dates_unavailable = []
    end

    def report_all_reservations
    end

    def report_reservations_for_day(date_julian)
      reservation_acceptable = true
      unless @dates_unavailable.empty?
        dates_unavailable.each do |date|
          if reservation.days_booked_am_and_pm.keys.include?(date)
            unless ( date[1][:am] == false ^ reservation.days_booked_am_and_pm[date][1][:am] == false) && (date[1][:pm] == false ^ reservation.days_booked_am_and_pm[1][:pm] == false )
              reservation_acceptable = false
            end
          end
        end
      end
      return reservation_acceptable
    end

    def add_reservation(reservation_acceptable?, reservation)
    end
  end
end
