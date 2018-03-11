require 'date'
require_relative 'spec_helper'

describe "FrontDesk class" do

  before do
    @front_desk_1 = Hotel::FrontDesk.new
  end

  describe "initialize" do

    before do
      @front_desk_0 = Hotel::FrontDesk.new
    end

    it "can be initialized" do

      @front_desk_0.must_be_instance_of Hotel::FrontDesk

    end

    it "stores an array of instances of room in its @rooms_basic variable equal to the number of rooms in the hotel" do

      @front_desk_0.rooms.must_be_kind_of Array
      @front_desk_0.rooms.each {|element| element.must_be_instance_of Hotel::Room}
      @front_desk_0.rooms.count.must_equal 20

    end

  end

  describe "generate_rooms" do

    before do
      @test_rooms_1 = @front_desk_1.generate_rooms
    end

    it "creates a collection of instances of Room, which it stores in an array." do

      @test_rooms_1.must_be_kind_of Array
      @test_rooms_1.each {|element| element.must_be_instance_of Hotel::Room}

    end


    it "gives each room a unique room number, in the form of a string, going from 1 through the total number of rooms in the facility" do


      rooms_in_order = @test_rooms_1.sort_by {|room| room.room_number.to_i}

      rooms_in_order.length.must_equal 20

      rooms_in_order.each_with_index do |room, index|
        room.room_number.must_equal (index + 1).to_s
      end
    end

  end

  describe "report_all_rooms" do

    it "reports a complete list of all the rooms in the facility" do

      room_report = @front_desk_1.report_all_rooms.sort_by {|room| room.room_number.to_i}

      room_report.must_be_kind_of Array
      room_report.length.must_equal 20

      room_report.each_with_index do |room, index|
        room.room_number.must_equal (index + 1).to_s
      end

    end
  end

  xdescribe "find_available_room(start_julian, end_julian)" do

    it "returns the ID of a room that is available between specified dates" do
    end

    it "returns nil if no rooms are available between specified dates" do
    end

  end

  xdescribe "create_reservation_basic(start_date_juli, end_date_juli, room_id)" do

    it "generates a reservation for a given date range" do
    end

    it "assigns the reservation to the hotel room specified" do
    end

  end

  # I think this is fully covered in the reservation class? But maybe there's a better way?

  # describe "report_reservation_price(id)" do
  # end

  xdescribe "report_all_reservations_day(date_julian)" do

    it "reports a list of reservations for a specified date" do
    end

  end

  xdescribe "report_all_available_rooms(start_dt_julian, end_dt_julian)" do

    it "reports a list of rooms that are available for a given date range" do
    end

  end

  #NOT EVEN GOING TO THINK ABOUT THIS PART RIGHT NOW.
  # describe "check_availability_for_block" do
  # end
  #
  # describe "create_room_block(block_size, block_discount)" do
  # end
  #
  # describe "report_available_block_rooms" do
  # end
  #
  # describe "create_reservation_block(start_date_jul, end_date_jul)" do
  # end
end












# Note:  COMMENTING THIS OUT FOR NOW.  WILL PROBABLY move this functionality to FrontDesk.
# it "Raises an error if the start date comes before the date of instantiation" do
#   too_early_start = '1st Feb 1975'
#   acceptible_end = '2nd Feb 3080'
#   proc{ Hotel::Reservation.new(too_early_start, acceptible_end) }.must_raise StandardError
# end
