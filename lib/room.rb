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
      all_reservations = nil
      unless @reservations.empty?
        all_reservations = @reservations
      end
      return all_reservations
    end

    def report_reservations_for_day(date_julian)
    end

    def can_accept_reservation?(reservation)
      reservation_acceptable = true
      unless @dates_unavailable.empty?
        dates_unavailable.each do |date|
          if reservation.days_booked_am_and_pm.keys.include?(date)
            am_conflict = nil
            pm_conflict = nil
            if (date[1][:am] == false) ^ (reservation.days_booked_am_and_pm[date][1][:am] == false)
              am_conflict = false
            else
              am_conflict = true
            end
            if ( date[1][:pm] == false ) ^ ( reservation.days_booked_am_and_pm[1][:pm] == false )
              pm_conflict = false
            else
              pm_conflict = true
            end
            unless am_conflict == false && pm_conflict == false
              reservation_acceptable = false
            end
          end
        end
      end
      return reservation_acceptable
    end

    # def add_reservation(reservation_acceptable?, reservation)
    #   if can_accept_reservation(reservation) == true
    #   else #Make an error or something
    #   end
    # end
  end
end
