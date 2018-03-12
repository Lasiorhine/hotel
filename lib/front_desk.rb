require 'date'
require 'pry'

require_relative 'reservation'
require_relative 'room'

module Hotel
  class FrontDesk

    attr_accessor   :rooms, :blocks

    TOTAL_ROOMS_IN_FACILITY = 20
    @@last_block_base = 100

    def initialize

      @rooms = generate_rooms
      @blocks = []

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

    def report_all_available_rooms(start_dt, end_dt, room_set)
      imaginary_reservation = Hotel::Reservation.new(start_dt, end_dt)
      all_available_rooms = []
      room_set.each do |room|
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

    def find_available_room(start_d, end_d, room_set)

      room_to_assign = nil
      rooms_available = report_all_available_rooms(start_d, end_d, room_set)
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

    def create_reservation_basic(start_date, end_date, room_set)
      room_numb_for_new_res = find_available_room(start_date, end_date, room_set)
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


    def check_block_feasibility(st_dt, end_dt,room_set, block_size)
      block_y_or_n = nil
      elig_for_block = report_all_available_rooms(st_dt, end_dt, room_set)
      if elig_for_block.length >= block_size
        block_y_or_n = {:yes => elig_for_block}
      else
        block_y_or_n = {:no => []}
      end
      return block_y_or_n
    end

    def create_placeholder_res(start_date, end_date, room_id, block_id)

      reservation_for_block = Hotel::Reservation.new(start_date, end_date)

      reservation_for_block.hotel_room_id = room_id
      reservation_for_block.block_set_aside = true
      reservation_for_block.block_id = block_id

      return reservation_for_block
    end

    def create_room_block(st_date, end_date, block_size, room_set, block_discount)
      feasability_result = check_block_feasibility(st_date, end_date, room_set, block_size)
      if feasability_result.keys.include?(:no)
        raise StandardError.new("There are not enough available rooms to create this block")
      else
        block_id = @@last_block_base.to_s
        @@last_block_base += 1
        rooms_available_for_block = feasability_result[:yes]
        room_surplus = rooms_available_for_block.length - block_size
        as_many_rooms_as_needed = rooms_available_for_block.drop(room_surplus)
        rooms_reserved_in_block = []
        as_many_rooms_as_needed.each do |room_id|
          room_for_block = locate_room_by_id(room_id)
          placeholder_res = create_placeholder_res(st_date, end_date, room_id, block_id)
          room_for_block.add_reservation(placeholder_res)
          block_availability_object = Hotel::BlockRoom.new(room_id, block_id, block_discount, st_date, end_date)
          block_availability_object.discount = block_discount
          rooms_reserved_in_block << block_availability_object
        end
        block = {block_id.to_sym => rooms_reserved_in_block}
        @blocks << block
      end
      return block
    end

    def check_availability_within_block(start_date, end_date, block_id)
      block_key = block_id.to_sym
      target_block = @blocks.find {|element| element.has_key?(block_key)}
      available_block_rooms = report_all_available_rooms(start_date, end_date, target_block.values[0])
      return available_block_rooms
    end

    # RIGHT HERE IS WHERE I RAN OUT OF GAS.

    #I ALMOST GOT THROGUH WAVE 3, but at 6:00 am, I just had nothing left.


    # def create_reservation_within_block(start_date, end_date, block_id)
    #   rooms_available = check_availability_within_block(start_date, end_date, block_id)
    #   room_instances_for_reservation = rooms_available.map {|id| @blocks.find }
    #
    #
    #   new_block_reservation = create_reservation_basic(start_date, end_date, rooms_available)
    #   return new_block_reservation
    # end
  end
end
