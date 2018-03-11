require 'date'
require 'pry'

require_relative 'reservation'
require_relative 'room'

module Hotel
  class FrontDesk

    attr_accessor   :rooms

    TOTAL_ROOMS_IN_FACILITY = 20

    def initialize

      @rooms = generate_rooms

    end

    def generate_rooms
      room_array = []
      for i in 1 .. TOTAL_ROOMS_IN_FACILITY
        room_number = i.to_s
        new_room = Hotel::Room.new(room_number)
        room_array << new_room
      end
      return room_array
    end

    def report_all_rooms
      all_rooms = @rooms
      return all_rooms
    end

    def find_all_reservations_for_date(date)
      query_date = DateTime.parse(date).jd.to_s
      overall_report = {}
      @rooms.each do |room|
        per_room_report = nil
        per_room_report = room.report_reservations_for_day(query_date)
        unless per_room_report == nil
          resv_id_array = []
          per_room_report.each {|reservation| resv_id_array << reservation.id }
          per_room_report = {room.room_number => resv_id_array}
          overall_report.merge!(per_room_report)
        end
      end
      return overall_report
    end

    def report_all_availabile_rooms(start_dt, end_dt)
    end

    def find_available_room(start_d, end_d)
      proposed_reservation = Hotel::Reservation.new(start_d, end_d)
      available_room = nil
      @rooms.each do |room|
        if available_room == nil
          availability = room.can_accept_reservation?(proposed_reservation)
          if availability[:accept] == true
            available_room = room
          end
        end
      end
      unless available_room == nil
        available_room = available_room.room_number
      end
      return available_room
    end

    def create_reservation_basic(start_date, end_date, room_id)
    end

    def report_reservation_price(id)
    end

    def report_all_reservations_day(date)
    end

    def report_all_availabile_rooms(start_dt, end_dt)
    end

    # def check_availability_for_block(st_dt, end_dt)
    # end
    #
    # def create_room_block(block_size, block_discount)
    # end
    #
    # def report_available_block_rooms(start_d, end_d)
    # end
    #
    # def create_reservation_block(start_date, end_date)
    # end
  end
end
