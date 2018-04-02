require 'date'
require 'pry'

require_relative 'reservation'
require_relative 'front_desk'

module Hotel
  class Room
    attr_reader :room_number, :base_resv_price, :min_res_sec, :rate_with_discount
    attr_accessor :discount, :reservations, :dates_unavailable, :block_set_asides

    BASE_RESERV_PRICE = 200.00
    MIN_RESERV_SECONDS = 36000

    def initialize(room_number)
      @room_number = room_number
      @base_resv_price = BASE_RESERV_PRICE
      @min_res_sec = MIN_RESERV_SECONDS
      @discount = 0.00
      @rate_with_discount = BASE_RESERV_PRICE - (BASE_RESERV_PRICE * @discount)
      @reservations = []
      @dates_unavailable = {}
      @block_set_asides = []
    end

    def report_all_reservations
      all_reservations = nil
      unless @reservations.empty?
        all_reservations = @reservations
      end
      return all_reservations
    end

    def report_reservations_for_day(date_julian)
      report = nil
      resvs_for_day = @reservations.find_all {|reservation| reservation.days_booked_am_and_pm[date_julian]}
      if resvs_for_day.any?
        report = resvs_for_day
      end
      return report
    end

    def report_reservation_status_for_day(date_julian)
      resvs_for_day = {@room_number => @dates_unavailable.fetch(date_julian, "no bookings")}
    end


    def can_accept_reservation?(reservation)
      reservation_acceptable = {:accept => true, :resolve_conflict => false}
      resolve_date_conflict = []
      unless @dates_unavailable.empty?
        unless reservation_acceptable[:accept] == false
          @dates_unavailable.each do |booked_date|
            # Note:  I originally had the am/pm conflict checking written as a single, long, one-line thing, but that made minitest lose its mind, so now it's in all these little chunks.
            date = booked_date
            if reservation.days_booked_am_and_pm.keys.include?(date[0])
              am_conflict = nil
              pm_conflict = nil
              if (date[1][:am] == false) ^ (reservation.days_booked_am_and_pm[date[0]][:am] == false)
                am_conflict = false
              else
                am_conflict = true
              end
              if  (date[1][:pm] == false)  ^  (reservation.days_booked_am_and_pm[date[0]][:pm] == false)
                pm_conflict = false
              else
                pm_conflict = true
              end
              unless am_conflict == false && pm_conflict == false
                reservation_acceptable = {:accept => false, :resolve_conflict => false}
              else
                conflicted_date_hash = {booked_date[0] => booked_date[1]}
                resolve_date_conflict << conflicted_date_hash
              end
            end
          end
        end
      end
      unless reservation_acceptable[:accept] == false
        if resolve_date_conflict.any?
          reservation_acceptable[:resolve_conflict] = resolve_date_conflict
        else
          reservation_acceptable[:resolve_conflict] = false
        end
      end
      return reservation_acceptable
    end


    def fix_conflicting_date(conflict_array)
      # This method needs a better name, but it does something
      # small but important.  For dates that include the start of
      # one reservation and the end of another, it creates a date hash
      # with :am and :pm values of true, which another method then
      # uses to replace the ones with false-s from the original
      # reservations. This keeps the can_accept_reservation? method
      # from going nuts in cases of abutting reservations.
      output_array = conflict_array.map {|d| {d.keys[0] => {:am => true, :pm => true}}}
    end

    def add_reservation(new_reservation)
      adding_instructions = can_accept_reservation?(new_reservation)
      if adding_instructions[:accept] == false
        raise StandardError.new ("You are trying to add a reservation that conflicts with a pre-existing reservation")
      else
        @reservations << new_reservation
        @dates_unavailable.merge!(new_reservation.days_booked_am_and_pm)
      end
      dates_with_conflicts_fixed = nil
      if adding_instructions[:resolve_conflict].kind_of? Array
        dates_with_conflicts_fixed = fix_conflicting_date(adding_instructions[:resolve_conflict])
        dates_with_conflicts_fixed.each {|date| @dates_unavailable.merge!(date)}
      end
    end
  end
end
