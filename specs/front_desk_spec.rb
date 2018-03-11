require 'date'
require_relative 'spec_helper'

describe "FrontDesk class" do

  describe "initialize" do
  end

  describe "generate_rooms" do

  end

  describe "report_all_rooms" do
  end

  describe "create_reservation_basic(start_date_juli, end_date_juli)" do
  end

  describe "report_reservation_price(id)" do
  end

  describe "report_all_reservations_day(date_julian)" do
  end

  describe "report_all_reservations_room(room)" do
  end

  describe "report_all_available_rooms(start_dt_julian, end_dt_julian)" do
  end

  describe "check_availability_for_block" do
  end

  describe "create_room_block(block_size, block_discount)" do
  end

  describe "report_available_block_rooms" do
  end

  describe "create_reservation_block(start_date_jul, end_date_jul)" do
  end
end












# Note:  COMMENTING THIS OUT FOR NOW.  WILL PROBABLY move this functionality to FrontDesk.
# it "Raises an error if the start date comes before the date of instantiation" do
#   too_early_start = '1st Feb 1975'
#   acceptible_end = '2nd Feb 3080'
#   proc{ Hotel::Reservation.new(too_early_start, acceptible_end) }.must_raise StandardError
# end
