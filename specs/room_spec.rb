require 'date'
require 'pry'
require_relative 'spec_helper'

describe "Room class" do
  before do

    @right_now = Time.now.to_s
    @two_days_ago = Time.at(Time.now.to_i - 172800).to_s
    @two_days_from_now = Time.at(Time.now.to_i + 172800).to_s

    @room_300_nominal = Hotel::Room.new("300")
    @room_400_no_res = Hotel::Room.new("400")

    @reservation_n1_nominal = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_1_follows_n1_directly = Hotel::Reservation.new('16th Oct 3013', '2nd Nov 3013')
    @reservation_2_overlaps_n1_beginning = Hotel::Reservation.new('8th Jun 3013', '11th Jun 3013')
    @reservation_3_overlaps_n1_end = Hotel::Reservation.new('15th Jun 3013', '5th Jul 3013')
    @reservation_n2_nominal = Hotel::Reservation.new('10th Jun 3014', '16th Jun 3014')
    @reservation_n3_nominal = Hotel::Reservation.new('10th Oct 3015', '9th Dec 3015')
  end
  describe "initialize(room_number)" do
    it "must have a room number encoded as a string" do
      @room_300_nominal.room_number.must_be_kind_of String
    end
    it "must accurately report its own room number" do
      @room_300_nominal.room_number.must_equal "300"
    end
    it "must store its reservations in an array" do
      @room_300_nominal.reservations.must_be_kind_of Array
    end
  end

  describe "report_all_reservations" do

    #THIS IS WHERE AN IMPORTANT HANDSHAKE BETWEEN RESERVATION AND ROOM NEEDS TO HAPPEN.
    it "returns a complete collection of reservations for the room" do
      all_nominal_reservations = [@reservation_n1_nominal, @reservation_n2_nominal, @reservation_n3_nominal]
      @room_300_nominal.reservations = all_nominal_reservations
      @room_300_nominal.report_all_reservations.must_equal all_nominal_reservations
    end

    it "returns nil when a room has no present or pending reservations" do
      @room_400_no_res.report_all_reservations.must_be_nil
    end

    it "performs properly when the room has a reservation that ends on the day on which the method is called" do
      @reservation_ending_today = Hotel::Reservation.new(@two_days_ago, @right_now)

    end

    it "performs properly when the room has a reservation that ends on the day on which the method is called" do

    end
  end

  describe "report_availability_for_day(date_julian)" do

    it "accurately reports reservations when run for a single day" do
    end

    it "accurately reports reservations for a range of days" do
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

  describe "add_reservation(new_reservation)" do


    it "must add itself to the room's collection of reservations" do

      @room_300_nominal.reservations << @reservation_n1_nominal
      before_reservations = @room_300_nominal.reservations.dup
      before_count = before_reservations.count
      @room_300_nominal.add_reservation(@reservation_n2_nominal)

      # The two assertions below just test the test
      before_reservations.must_include @reservation_n1_nominal
      before_count.must_equal 1

      @room_300_nominal.reservations.count.must_equal 2
      @room_300_nominal.reservations.must_include @reservation_n1_nominal
      @room_300_nominal.reservations.must_include @reservation_n2_nominal
    end

    it "performs properly if a room has no other pending reservations" do

      before_reservations = @room_400_no_res.reservations.dup
      @room_400_no_res.add_reservation(@reservation_n3_nominal)

      #The assertion below just tests the test
      before_reservations.must_be_empty

      @room_400_no_res.reservations.count.must_equal 1
      @room_400_no_res.reservations.must_include @reservation_n3_nominal

    end

    it "must add the dates of the reservation to the room's collection of unavailable dates" do

      before_unavailables =  @room_300_nominal.dates_unavailable.dup
      before_unavailables.count.must_equal 0

      @room_300_nominal.add_reservation(@reservation_n1_nominal)
      @room_300_nominal.dates_unavailable.count.must_equal 7
      @room_300_nominal.dates_unavailable.keys.must_include "2821697"

    end

  end
end
