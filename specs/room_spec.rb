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
    @room_500_misc_tests = Hotel::Room.new("500")

    @reservation_n1_nominal = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_n2_nominal = Hotel::Reservation.new('10th Jun 3014', '16th Jun 3014')
    @reservation_n3_nominal = Hotel::Reservation.new('10th Oct 3015', '9th Dec 3015')

    @reservation_0_precedes_n1_directly = Hotel::Reservation.new('5th Jun 3013', '10th Jun 3013')
    @reservation_1_follows_n1_directly = Hotel::Reservation.new('16th Jun 3013', '2nd Jul 3013')
    @reservation_2_overlaps_n1_beginning = Hotel::Reservation.new('8th Jun 3013', '11th Jun 3013')
    @reservation_3_overlaps_n1_end = Hotel::Reservation.new('15th Jun 3013', '5th Jul 3013')
    @reservation_4_overlaps_n1_precedes_n2 = Hotel::Reservation.new('14th Jun 3013', '10th Jun 3014')
    @reservation_5_follows_n1_precedes_n2 = Hotel::Reservation.new('16th Jun 3013', '10th Jun 3014')

    @reservation_a_single_night = Hotel::Reservation.new('1st Nov 3013', '2nd Nov 3013')
    @reservation_b_single_night = Hotel::Reservation.new('1st Nov 3013', '2nd Nov 3013')

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

  end

  describe "report_availability_for_day(date_julian)" do

    it "accurately reports reservations when run for a single day" do
    end

    it "accurately reports reservations for a range of days" do
    end

  end

  describe "can_accept_reservation?(reservation)" do

    before do
      @room_300_nominal.add_reservation(@reservation_n1_nominal)
    end

    xit "returns the value '{:accept => true, :resolve_conflict => false}' if the proposed reservation does not conflict with or share a starting/ending date with an existing reservation" do

      acceptability_result = @room_300_nominal.can_accept_reservation?(@reservation_n2_nominal)

      acceptability_result[:accept].must_equal true
      acceptability_result[:resolve_conflict].must_equal false

    end

    xit "gives a value {:accept => false, :resolve_conflict => false} for a new reservation that has a whole-day conflict with an existing reservation " do

      early_conflict_result = @room_300_nominal.can_accept_reservation?(@reservation_2_overlaps_n1_beginning)
      late_conflict_result = @room_300_nominal.can_accept_reservation?(@reservation_3_overlaps_n1_end)


      early_conflict_result[:accept].must_equal false
      early_conflict_result[:resolve_conflict].must_equal false

      late_conflict_result[:accept].must_equal false
      late_conflict_result[:resolve_conflict].must_equal false
    end

    xit "gives a value {:accept => false, :resolve_conflict => false} for a one-night reservation that conflicts with an existing one-night reservation" do

      @room_500_misc_tests.add_reservation(@reservation_a_single_night)
      single_day_conf_result = @room_500_misc_tests.can_accept_reservation?(@reservation_b_single_night)

      single_day_conf_result[:accept].must_equal false
      single_day_conf_result[:resolve_conflict].must_equal false

    end

    xit "gives a value {:accept => false, :resolve_conflict => false} when there is an acceptable start-and-end conflict with one existing reservation, and a full-day conflict with another reservation" do

      @room_300_nominal.add_reservation(@reservation_n2_nominal)

      acceptible_and_not_result = @room_300_nominal.can_accept_reservation?(@reservation_4_overlaps_n1_precedes_n2)

      acceptible_and_not_result[:accept].must_equal false
      acceptible_and_not_result[:resolve_conflict].must_equal false

    end

    it "gives a value of {:accept => true, :resolve_conflict => [foo1], where foo1 is a hash of the date of the start-date/end-date overlap, when a proposed reservation starts on the day an existing reservation ends" do

      follows_result = @room_300_nominal.can_accept_reservation?(@reservation_1_follows_n1_directly)

      follows_result[:accept].must_equal true
      follows_result[:resolve_conflict].must_be_kind_of Array
      follows_result[:resolve_conflict].count.must_equal 1
      follows_result[:resolve_conflict][0].must_be_kind_of Hash
      # Note:  This number is the date of the start-end overlap, respresented as a Julian date in string form.
      follows_result[:resolve_conflict][0].keys.must_include "2821702"

    end

    xit "gives a value of {:accept => true, :resolve_conflict => [foo1],  where foo1 is a hash of the date of the start-date/end-date overlap, when a proposed reservation ends on the day an existing reservation starts" do

      precedes_result = @room_300_nominal.can_accept_reservation?(@reservation_0_precedes_n1_directly)

      precedes_result[:accept].must_equal true
      precedes_result[:resolve_conflict].must_be_kind_of Array
      precedes_result[:resolve_conflict].count.must_equal 1
      precedes_result[:resolve_conflict][0].must_be_kind_of Hash
      # Note:  This number is the date of the start-end overlap, respresented as a Julian date in string form.
      follows_result[:resolve_conflict][0][0].must_equal "2821695"

    end

    xit "gives a value of {:accept => false, :resolve_conflict => [foo1, foo2], where foo1 and foo2 are hashes of the dates of the start-date/end-date overlaps, when a proposed reservation starts on the day an existing reservation ends, and ends on the day an existing reservation starts" do

      @room_300_nominal.add_reservation(@reservation_n2_nominal)
      in_middle_result = @room_300_nominal.can_accept_reservation?(@reservation_5_follows_n1_precedes_n2)

      in_middle_result[:accept].must_equal true
      in_middle_result[:resolve_conflict].must_be_kind_of Array
      in_middle_result[:resolve_conflict].count.must_equal 2
      in_middle_result[:resolve_conflict][0].must_be_kind_of Hash
      # Note:  This number is the date of the first start-end overlap, respresented as a Julian date in string form.
      in_middle_result[:resolve_conflict][0][0].must_equal "2821701"
      in_middle_result[:resolve_conflict][1].must_be_kind_of Hash
      # Note:  This number is the date of the second start-end overlap, respresented as a Julian date in string form.
      in_middle_result[:resolve_conflict][1][0].must_equal "2822060"
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
