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

    # Note:  COMMENTING THIS OUT FOR NOW.  WILL PROBABLY move this functionality to FrontDesk.
    # it "Raises an error if the start date comes before the date of instantiation" do
    #   too_early_start = '1st Feb 1975'
    #   acceptible_end = '2nd Feb 3080'
    #   proc{ Hotel::Reservation.new(too_early_start, acceptible_end) }.must_raise StandardError
    # end

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

  describe "days_with_am_and_pm_occupation" do

    before do
      @nominal_understand_days = @reservation_0_nominal_6n.days_with_am_and_pm_occupation
      @start_date_hash = @nominal_understand_days.fetch(@reservation_0_nominal_6n.start_date.jd.to_s)
      @end_date_hash = @nominal_understand_days.fetch(@reservation_0_nominal_6n.end_date.jd.to_s)
    end

    it "returns a hash" do
      @nominal_understand_days.must_be_kind_of Hash
    end

    it "contains a key-value pair for each day of the reservation" do
      @nominal_understand_days.count.must_equal 7
    end

    it "must be composed of key-value pairs in which all the keys are Julian dates in string form" do
      @nominal_understand_days.each_key.must_be_kind_of String
      @nominal_understand_days.each_key.must_match /^24[56]\d{4}$/
    end

    it "must be composed of key-value pairs in which all the values are hashes" do
      @nominal_understand_days.each_value.must_be_instance_of Hash
    end

    it "must be composed of key-value pairs in which the value is a hash which contains two keys, :am and :pm" do
      @nominal_understand_days.each_value.count.must_equal 2
      @nominal_understand_days.each_value.has_key?(:am).must_equal true
      @nominal_understand_days.each_value.has_key?(:pm).must_equal true
    end

    it "must contain a key-value pair for the start date in which the key is the start date, and the value is a 2-item hash, wherein the :am key's value is 'false' and the :pm key's value is 'true'" do

      @nominal_understand_days.has_key?(@reservation_0_nominal_6n.start_date.jd.to_s).must_equal true
      @start_date_hash.count.must_equal 1
      @start_date_hash[1].fetch(:am).must_equal false
      @start_date_hash[1].fetch(:pm).must_equal true
    end


    it "must contain a key-value pair for the end date in which the key is the end date, and the value is a 2-item hash, wherein which the :am key's value is 'true' and the :pm key's value is 'false'" do

      @nominal_understand_days.has_key?(@reservation_0_nominal_6n.end_date.jd.to_s).must_equal true
      @end_date_hash.count.must_equal 1
      @end_date_hash[1].fetch(:am).must_equal true
      @end_date_hash[1].fetch(:pm).must_equal false
    end

    it "must include a hash for each FULL DAY (i.e, non-starting or ending day) of the reservation in which the value contains exactly two key-value pairs, one with a key of :am, and one with a key of :pm, and both with a value of 'true'" do
      test_copy_nominal_understand_1 = @nominal_understand_days.dup
      no_start_test = (test_copy_nominal_understand_1.delete(@reservation_0_nominal_6n.start_date.jd.to_s)).dup
      no_start_or_end_test = (no_start_test.delete(@reservation_0_nominal_6n.end_date.jd.to_s)).dup
      first_res_day_julian = @reservation_0_nominal_6n.start_date.jd.to_i
      last_res_day_julian = @reservation_0_nominal_6n.end_date.jd.to_i
      if last_res_day_julian - first_res_day_julian > 1
        value_array = []
        no_start_or_end_test.each do |full_day|
          value_array = []
          full_day.value.each_value{|value| value_array << value}
          value_array.must_equal [true, true]
        end
        key_array = []
        no_start_or_end_test.each_key {|key| key_array << key}
        key_array.sort!
        key_array.each_with_index do |key, index|
          (key.to_i + index + 1).must_equal (first_res_day_julian + index + 1)
        end
      end
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
