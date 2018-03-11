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

    def report_all_available_rooms(start_dt, end_dt)
      imaginary_reservation = Hotel::Reservation.new(start_dt, end_dt)
      all_available_rooms = []
      @rooms.each do |room|
        available_room = nil
        availability = room.can_accept_reservation?(imaginary_reservation)
        if availability[:accept] == true
          available_room = room
        end
        unless available_room == nil
          available_room = available_room.room_number
          all_available_rooms << available_room
        end
      end
      return all_available_rooms
    end

    def find_available_room(start_d, end_d)

      room_to_assign = nil
      rooms_available = report_all_available_rooms(start_d, end_d)
      unless rooms_available.empty?
        rooms_by_int = rooms_available.map{ |rm_numb| rm_numb.to_i }
        rooms_by_int.sort!
        room_to_assign = rooms_by_int[0].to_s
      end
      return room_to_assign
    end

    def look_up_per_night_price_for_room(query_room_numb)
      target_room = @rooms.find {|room| room.room_number == query_room_numb}
      target_price = target_room.rate_with_discount
    end

    def locate_room_by_id(query_rm_numb)
      target_room = @rooms.find {|room| room.room_number == query_rm_numb}
      return target_room
    end

    def create_reservation_basic(start_date, end_date)
      room_numb_for_new_res = find_available_room(start_date, end_date)
      if room_numb_for_new_res.nil?
        raise StandardError.new ("Alas, no rooms are available for this reservation.")
      else
        new_reservation = Hotel::Reservation.new(start_date, end_date)
      end
      new_reservation.hotel_room_id = room_numb_for_new_res

      new_reservation.per_night_price = look_up_per_night_price_for_room(room_numb_for_new_res)

      room_instance_for_res = locate_room_by_id(room_numb_for_new_res)

      room_instance_for_res.add_reservation(new_reservation)

      return new_reservation
    end



    def find_reservation_price(query_id)

      target_reservation = nil
      price_of_target = nil
      @rooms.each do |room|
        unless target_reservation != nil
          room.reservations.each do |reservation|
            if reservation.id == query_id
              target_reservation = reservation
              price_of_target = target_reservation.total_reservation_cost
            end
          end
        end
      end
      return price_of_target
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
