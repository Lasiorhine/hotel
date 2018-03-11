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
    @room_600_misc_tests = Hotel::Room.new("600")

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

    it "returns a complete collection of reservations for the room" do
      all_nominal_reservations = [@reservation_n1_nominal, @reservation_n2_nominal, @reservation_n3_nominal]
      @room_300_nominal.reservations = all_nominal_reservations
      @room_300_nominal.report_all_reservations.must_equal all_nominal_reservations
    end

    it "returns nil when a room has no present or pending reservations" do
      @room_400_no_res.report_all_reservations.must_be_nil
    end

  end

  describe "report_reservations_for_day(date_julian)" do
    before do

      @room_300_nominal.add_reservation(@reservation_n1_nominal)
      @room_300_nominal.add_reservation(@reservation_1_follows_n1_directly)
      @room_300_nominal.add_reservation(@reservation_n3_nominal)

    end

    it "accurately reports reservations for a day on which there is a single reservation" do

      jun_12_reservations = @room_300_nominal.report_reservations_for_day("2821698")
      jun_12_reservations.must_be_kind_of Array
      jun_12_reservations.length.must_equal 1
      jun_12_reservations.must_include @reservation_n1_nominal

    end

    it "accurately reports reservations when run for a day on which one reservation begins and another ends" do

      jun_16_reservations = @room_300_nominal.report_reservations_for_day("2821702")
      jun_16_reservations.length.must_equal 2
      jun_16_reservations.must_be_kind_of Array
      jun_16_reservations.must_include @reservation_n1_nominal
      jun_16_reservations.must_include @reservation_1_follows_n1_directly

    end

    it "returns nil if a room has no reservations for a given day." do

      xmas_3075_reservations = @room_300_nominal.report_reservations_for_day("2844539")

      xmas_3075_reservations.must_be_nil

    end
  end

  describe "can_accept_reservation?(reservation)" do

    before do
      @room_300_nominal.add_reservation(@reservation_n1_nominal)
    end

    it "returns the value '{:accept => true, :resolve_conflict => false}' if the proposed reservation does not conflict with or share a starting/ending date with an existing reservation" do

      acceptability_result = @room_300_nominal.can_accept_reservation?(@reservation_n2_nominal)

      acceptability_result[:accept].must_equal true
      acceptability_result[:resolve_conflict].must_equal false

    end

    it "gives a value {:accept => false, :resolve_conflict => false} for a new reservation that has a whole-day conflict with an existing reservation " do

      early_conflict_result = @room_300_nominal.can_accept_reservation?(@reservation_2_overlaps_n1_beginning)
      late_conflict_result = @room_300_nominal.can_accept_reservation?(@reservation_3_overlaps_n1_end)


      early_conflict_result[:accept].must_equal false
      early_conflict_result[:resolve_conflict].must_equal false

      late_conflict_result[:accept].must_equal false
      late_conflict_result[:resolve_conflict].must_equal false
    end

    it "gives a value {:accept => false, :resolve_conflict => false} for a one-night reservation that conflicts with an existing one-night reservation" do

      @room_500_misc_tests.add_reservation(@reservation_a_single_night)
      single_day_conf_result = @room_500_misc_tests.can_accept_reservation?(@reservation_b_single_night)

      single_day_conf_result[:accept].must_equal false
      single_day_conf_result[:resolve_conflict].must_equal false

    end

    it "gives a value {:accept => false, :resolve_conflict => false} when there is an acceptable start-and-end conflict with one existing reservation, and a full-day conflict with another reservation" do

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

    it "gives a value of {:accept => true, :resolve_conflict => [foo1],  where foo1 is a hash of the date of the start-date/end-date overlap, when a proposed reservation ends on the day an existing reservation starts" do

      precedes_result = @room_300_nominal.can_accept_reservation?(@reservation_0_precedes_n1_directly)

      precedes_result[:accept].must_equal true
      precedes_result[:resolve_conflict].must_be_kind_of Array
      precedes_result[:resolve_conflict].count.must_equal 1
      precedes_result[:resolve_conflict][0].must_be_kind_of Hash
      # Note:  This number is the date of the start-end overlap, respresented as a Julian date in string form.
      precedes_result[:resolve_conflict][0].keys.must_include "2821696"

    end

    it "gives a value of {:accept => false, :resolve_conflict => [foo1, foo2], where foo1 and foo2 are hashes of the dates of acceptable start-date/end-date overlaps, when a proposed reservation begins on the day an existing reservation ends, and ends on the day an existing reservation begins" do

      @room_300_nominal.add_reservation(@reservation_n2_nominal)
      in_middle_result = @room_300_nominal.can_accept_reservation?(@reservation_5_follows_n1_precedes_n2)

      in_middle_result[:accept].must_equal true
      in_middle_result[:resolve_conflict].must_be_kind_of Array
      in_middle_result[:resolve_conflict].count.must_equal 2
      in_middle_result[:resolve_conflict][0].must_be_kind_of Hash

      # Note:  This number is the date of the first start-end overlap, respresented as a Julian date in string form.
      in_middle_result[:resolve_conflict][0].keys.must_include "2821702"
      in_middle_result[:resolve_conflict][1].must_be_kind_of Hash

      # Note:  This number is the date of the second start-end overlap, respresented as a Julian date in string form.
      in_middle_result[:resolve_conflict][1].keys.must_include "2822061"
    end
  end

  describe "fix_conflicting_date(conflict_array)" do

    before do
      @conflict_array_1 = [
                            { "28281899" =>
                              { :am => false, :pm => true }
                            }
                          ]

      @conflict_array_2 = [
                          {"28281802" =>
                            { :am => false, :pm => true }
                          },

                          {"28281807" =>
                            { :am => true, :pm => false }
                            }
                          ]
      @conf_res_output_array_1 = @room_500_misc_tests.fix_conflicting_date(@conflict_array_1)

      @conf_res_output_array_2 = @room_600_misc_tests.fix_conflicting_date(@conflict_array_2)

      @times_all_true_hash = {:am => true, :pm => true}
    end

    it "outputs an array that is the same length as its input array" do
      before_length_1 = @conflict_array_1.length
      before_length_2 = @conflict_array_2.length

      @conf_res_output_array_1.length.must_equal before_length_1
      @conf_res_output_array_2.length.must_equal before_length_2
    end

    it "outputs an array of date-hashes that have the same keys (Julian dates in string form) as its input-hashes" do

      @conf_res_output_array_1[0].keys.must_equal @conflict_array_1[0].keys

      @conflict_array_2[0].keys.must_equal @conflict_array_2[0].keys

      @conf_res_output_array_2[1].keys.must_equal  @conflict_array_2[1].keys

    end

    it "outputs an array that contains one or more date-hashes, where the key of each is a Julian date in string form, and the value is a hash of two hashes, with keys :am and :pm, and a value of true for each" do

        @conf_res_output_array_1[0].values[0].must_equal @times_all_true_hash

        @conf_res_output_array_2[0].values[0].must_equal @times_all_true_hash

        @conf_res_output_array_2[1].values[0].must_equal @times_all_true_hash

    end
  end
  describe "add_reservation(new_reservation)" do


    it "adds itself to the room's collection of reservations" do

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

    it "adds the dates of the reservation to the room's collection of unavailable dates" do

      before_unavailables =  @room_300_nominal.dates_unavailable.dup
      before_unavailables.count.must_equal 0

      @room_300_nominal.add_reservation(@reservation_n1_nominal)
      @room_300_nominal.dates_unavailable.count.must_equal 7
      @room_300_nominal.dates_unavailable.keys.must_include "2821697"
    end

    it "raises a standard error if an attempt is made to add a reservation that conflicts with an existing reservation" do

      #Note -- at this time, my plan is actually for this to happen in FrontDesk, but all the machinery is present to make this happen here as well, so maybe I'll just go ahead and do this?
      @room_300_nominal.add_reservation(@reservation_n1_nominal)

      proc{ @room_300_nominal.add_reservation(@reservation_2_overlaps_n1_beginning)}.must_raise StandardError


    end

    it "creates a date hash with values of true for both :am and :pm for any date on which a (non-conflicting) new reservation's start or end date falls on the start or end date of a pre-existing reservation and logs it in the room's @dates_unavailable hash. " do

      @room_300_nominal.add_reservation(@reservation_n1_nominal)
      room_before_booked = @room_300_nominal.dates_unavailable.dup
      new_res_before_dates = @reservation_1_follows_n1_directly.days_booked_am_and_pm.dup

      # The assertions below just test the test.
      room_before_booked.count.must_equal 7
      new_res_before_dates.count.must_equal 17
      room_before_booked["2821702"][:pm].must_equal false
      new_res_before_dates["2821702"][:am].must_equal false

      @room_300_nominal.add_reservation(@reservation_1_follows_n1_directly)
      dates_after_adding_and_conf_res = @room_300_nominal.dates_unavailable.dup

      dates_after_adding_and_conf_res.count.must_equal 23
      dates_after_adding_and_conf_res["2821702"][:am].must_equal true
      dates_after_adding_and_conf_res["2821702"][:pm].must_equal true

    end

  end
end
