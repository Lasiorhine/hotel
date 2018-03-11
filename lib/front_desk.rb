require 'date'
require 'pry'

require_relative 'reservation'
require_relative 'room'

module Hotel
  class FrontDesk

    attr_reader   :rooms

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

    def find_available_room(start_julian, end_julian)
    end

    def create_reservation_basic(start_date_juli, end_date_juli, room_id)
    end

    def report_reservation_price(id)
    end

    def report_all_reservations_day(date_julian)
    end

    def report_all_availabile_rooms(start_dt_julian, end_dt_julian)
    end

    def check_availability_for_block(stt_dt_jln, end_dt_jln)
    end

    def create_room_block(block_size, block_discount)
    end

    def report_available_block_rooms(start_julian, end_julian)
    end

    def create_reservation_block(start_date_jul, end_date_jul)
    end


  end
end
