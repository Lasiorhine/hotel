require 'date'
require 'pry'

require_relative 'reservation'
require_relative 'front_desk'

module Hotel
  class Room
    attr_accessor :room_number, :reservations, :dates_unavailable

    def initialize(room_number)
      @room_number = room_number
      @reservations = []
      @dates_unavailable = {}
    end

    def report_all_reservations
      all_reservations = nil
      unless @reservations.empty?
        all_reservations = @reservations
      end
      return all_reservations
    end

    def report_reservations_for_day(date_julian)
      # THIS NEEDS TO BE TESTED AFTER THE RESERVATION-ADDING MECHANICS GO IN, BECAUSE IT WILL READ FROM 'Dates Unavailable.'
    end

    def can_accept_reservation?(reservation)
      reservation_acceptable = {:accept => true, :resolve_conflict => false}
      resolve_date_conflict = []
      unless @dates_unavailable.empty?
        puts "unless at 33"
        unless reservation_acceptable[:accept] == false
          puts "unless at 35"
          @dates_unavailable.each do |booked_date|
            # Note:  I originally had the am/pm conflict checking written as a single, long, one-line thing, but that made minitest loose its mind, so now it's in all these little chunks.
            date = booked_date
            if reservation.days_booked_am_and_pm.keys.include?(date[0])
              am_conflict = nil
              pm_conflict = nil
              puts "if at 42"
              if (date[1][:am] == false) ^ (reservation.days_booked_am_and_pm[date[0]][:am] == false)
                am_conflict = false
                puts "if at 45"
              else
                am_conflict = true
                puts "else at 46"
              end
              if  (date[1][:pm] == false)  ^  (reservation.days_booked_am_and_pm[date[0]][:pm] == false)
                pm_conflict = false
                puts "if at 52"
              else
                pm_conflict = true
                puts "else at 53"
              end
              unless am_conflict == false && pm_conflict == false
                reservation_acceptable = {:accept => false, :resolve_conflict => false}
                puts "unless at 59"
              else
                conflicted_date_hash = {booked_date[0] => booked_date[1]}
                resolve_date_conflict << conflicted_date_hash
                puts "else at 62"
              end
            end
          end
        end
      end
      unless reservation_acceptable[:accept] == false
        puts "unless at 69"
        if resolve_date_conflict.any?
          reservation_acceptable[:resolve_conflict] = resolve_date_conflict
          puts "if at 72"
        else
          reservation_acceptable[:resolve_conflict] = false
          puts "else at 75"
        end
      end
      puts "end at 78"
      return reservation_acceptable
    end

    def add_reservation(new_reservation)
      #PROCESS NOTES:  THink I'm going to write this method, then add in the rejection mechanics, even tough the rejection mechanics are already kind of there. The commented-out if/else business below will be retrofitted on.
      # if can_accept_reservation(reservation) == true
      # else #Make an error or something
      # end
      @reservations << new_reservation
      @dates_unavailable.merge!(new_reservation.days_booked_am_and_pm)
    end
  end
end
