require 'date'
require 'pry'
require_relative 'spec_helper'

describe "Reservation class" do

  before do
    @reservation_0_nominal_6n = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_1_1n = Hotel::Reservation.new('1st Oct 3080', '2nd Oct 3080')
    @reservation_2_2n = Hotel::Reservation.new('1st Nov 3081', '3rd Nov 3081')
    @reservation_3_35n = Hotel::Reservation.new('1st Dec 3082', '5th Jan 3083')
  end

  describe "initialize" do

    it "is an instance of Reservation" do
      @reservation_0_nominal_6n.must_be_instance_of Hotel::Reservation
    end

    it "has a start date that is an instance of Ruby's Date class" do
      @reservation_0_nominal_6n.start_date.must_be_instance_of DateTime
    end

    it "has an end date that is an instance of Ruby's Date class" do
      @reservation_0_nominal_6n.end_date.must_be_instance_of DateTime
    end

    it "Raises an error if the start date comes before the date of instantiation" do
      too_early_start = '1st Feb 1975'
      acceptible_end = '2nd Feb 3080'
      proc{ Hotel::Reservation.new(too_early_start, acceptible_end) }.must_raise StandardError
    end

    it "raises an error if the end date is not at least one day after the end date" do
      late_start = '3rd May 3075'
      early_end = '3rd May 3075'
      proc{ Hotel::Reservation.new(late_start, early_end) }.must_raise StandardError
    end
  end

  describe "assign_id" do
    it "creates an eight-digit id" do
      @reservation_0_nominal_6n.id.to_s.must_match /^\d{8}$/
      @reservation_3_35n.id.to_s.must_match /^\d{8}$/
    end

    it "generates an ID number that is one higher than the next-highest ID number" do
      @reservation_2_2n.id.to_i.must_equal 1 + @reservation_1_1n.id.to_i
      @reservation_3_35n.id.to_i.must_equal 2 + @reservation_1_1n.id.to_i
    end
  end

  describe "calculate_total_nights" do
    before do
      @r_0_nominal_nights = @reservation_0_nominal_6n.calculate_total_nights
    end
    it "returns an integer" do
      @r_0_nominal_nights.must_be_kind_of Integer
    end
    it "correctly calculates the length of a nominal stay" do
      @r_0_nominal_nights.must_equal 6
    end
    it "correctly calculates the length of a stay that begins in one year and ends in another" do
      @reservation_3_35n.calculate_total_nights.must_equal 35
    end
    it "correctly calculates teh length of a stay that is one night long" do
      @reservation_1_1n.calculate_total_nights.must_equal 1
    end
  end

  describe "calculate_reservation_price" do
    it "returns a float rounded to two decimal places" do
      @reservation_0_nominal_6n.calculate_reservation_price.must_be_kind_of Float
      @reservation_0_nominal_6n.calculate_reservation_price.to_s.must_match /^\d+\.\d{1,2}$/
    end

    it "accurately returns the product of the room's per-day price and the length (in days) of the reservation" do
      @reservation_0_nominal_6n.calculate_reservation_price.must_be_within_delta 600.00, 0.003
      @reservation_1_1n.calculate_reservation_price.must_be_within_delta 100.00, 0.003
      @reservation_3_35n.calculate_reservation_price.must_be_within_delta 3500.00, 0.003
    end
  end
end
