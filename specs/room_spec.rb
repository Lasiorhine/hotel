require 'date'
require_relative 'spec_helper'

describe "Room class" do
  before do
    @room_300 = Hotel::Room.new("300")
    )
    @reservation_n_nominal_6n = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_1_follows_n_directly = Hotel::Reservation.new('16th Oct 3013', '2nd Nov 3013')
    @reservation_2_overlaps_n_beginning = Hotel::Reservation.new('8th Jun 3013', '11th Jun 3013')
    @reservation_3_overlaps_n_end = Hotel::Reservation.new('15th Jun 3013', '5th Jul 3013')
  end
  describe "initialize(room_number)" do
    it "must have a room number encoded as a symbol" do
      @room_300.room_number.must_be_kind_of Symbol
    end
    it "must accurately report its own room number" do
      @room_300.room_number.must_equal :300
    end
    it "must store its reservations in an array" do
      @room_300.reservations.must_be_kind_of Array
    end
  end

  describe "report_all_reservations" do

    it "returns a complete collection of reservations for the room" do
    end

    it "returns nil when a room has no present or pending reservations" do
    end

    it "performs properly when the room is reserved on the same day the method is called" do
    end
  end

  describe "report_availability(date)" do

    it "accurately reports reservations when run for the current day" do
    end

    it "accurately reports reservations for a future date" do
    end

    it "accurately reports reservations for a date in the past" do
    end
  end

  describe "can_accept_reservation?(reservation)" do

    it "returns true if the proposed reservation does not conflict with an existing reservation" do
    end

    it "returns false if the proposed reservation conflicts with an existing reservation" do
    end

    it "accepts a reservation when the start date is the same as the date of the request, assuming no other conflicts" do
    end

    it "accepts a reservation that begins the same day another reservation ends, assuming no other conflicts" do
    end

    it "accepts a reservation when its start date, the date of the request, and the end date of another reservation are all the same, assuming o other conflicts" do
    end

    it "rejects a reservation that begins the same date as the date of the request, if another conflict exists" do
    end 

  end

  describe "add_reservation(reservation)" do
    it "must add itself to the room's collection of reservations" do
    end

    it "must add the dates of the reservation to the room's collection of unavailable dates"
    end
end
