require 'date'
require_relative 'spec_helper'

describe "FrontDesk class" do

  describe "initialize" do

    it "stores an array of instances of room in its @rooms_basic variable" do
    end

    it "begins with an empty array as the value of its @rooms_block variable" do
    end
  end

  describe "generate_rooms" do

    it "creates a collection of instances of room, which it stores in an array." do
    end

    it "gives each room a unique room number, in the form of a string, going from 1 through the total number of rooms in the facility" do
    end

  end

  describe "report_all_rooms" do

    it "reports a complete list of all the rooms in the facility" do
    end

  end

  describe "find_available_room(start_julian, end_julian)" do

    it "returns the ID of a room that is available between specified dates" do
    end

    it "returns nil if no rooms are available between specified dates" do
    end

  end

  describe "create_reservation_basic(start_date_juli, end_date_juli, room_id)" do

    it "generates a reservation for a given date range" do
    end

    it "assigns the reservation to the hotel room specified" do
    end

  end

  # I think this is fully covered in the reservation class? But maybe there's a better way?

  # describe "report_reservation_price(id)" do
  # end

  describe "report_all_reservations_day(date_julian)" do

    it "reports a list of reservations for a specified date" do
    end

  end

  describe "report_all_available_rooms(start_dt_julian, end_dt_julian)" do

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
