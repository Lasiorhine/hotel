require 'date'
require_relative 'spec_helper'

describe "Reservation class" do

  before do
    @reservation_0_nominal = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
  end

  describe "initialize" do

    it "is an instance of Reservation" do
      @reservation_0_nominal.must_be_instance_of Hotel::Reservation
    end

    it "has a start date that is an instance of Ruby's Date class" do
      @reservation_0_nominal.start_date.must_be_instance_of DateTime
    end

    it "has an end date that is an instance of Ruby's Date class" do
      @reservation_0_nominal.end_date.must_be_instance_of DateTime
    end

    it "Raises an error if the start date comes before the date of instantiation" do
      too_early_start = '1st Feb 1975'
      acceptible_end = '2nd Feb 3080'
      proc{ Hotel::Reservation.new(too_early_start, acceptible_end) }.must_raise StandardError
    end

    it "raises an error if the end date is not at least one day after the end date" do
      late_start = '3rd May 3075'
      early_end = '1st May 3075'
      proc{ Hotel::Reservation.new(late_start, early_end) }.must_raise StandardError
    end

    it "has a unique, six-digit ID number that is one higher than the next-highest ID number" do
      @reservation_1_id_check = Hotel::Reservation.new('1st Oct 3080', '4th Oct 3080')
      @reservation_2_id_check = Hotel::Reservation.new('1st Nov 3081', '4th Nov 3081')
      @reservation_3_id_check = Hotel::Reservation.new('1st Dec 3082', '5th Dec 3082')

      @reservation_2_id_check.id.to_i.must_equal 1 + @reservation_1_id_check.id.to_i
      @reservation_3_id_check.id.to_i.must_equal 2 + @reservation_1_id_check.id.to_i
    end

  end

  describe "calculate_cumulative_price" do

    it "returns a float rounded to two decimal places" do
      @reservation_0_nominal.calculate_cumulative_price.must_be_kind_of Float
      @reservation_0_nominal.calculate_cumulative_price.must_match /^\d+\.\d{2}$/
    end

    it "accurately returns the product of the room's per-day price and the length (in days) of the reservation" do
      @reservation_0_nominal.calculate_cumulative_price.must_be_within_delta 600.00, 0.003
    end
  end
end
