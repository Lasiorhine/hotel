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

      @end_date_hash = @nominal_understand_days.fetch(@reservation_0_nominal_6n.end_date.jd.to_s)
    end

    it "returns a hash" do
      @nominal_understand_days.must_be_kind_of Hash
    end

    it "contains a key-value pair for each day of the reservation" do
      @nominal_understand_days.count.must_equal 7
    end

    it "must be composed of key-value pairs in which all the keys are Julian dates in string form" do
      @nominal_understand_days.each do |k, v|
        k.must_be_kind_of String
        # Conversion note: This test uses a hard-coded seven-date range that starts with Junee 10, 3013
        k.must_match /^2821\d{3}$/
      end
    end

    it "must be composed of key-value pairs in which all the values are hashes" do
      @nominal_understand_days.each do |k, v|
        v.must_be_kind_of Hash
      end
    end

    it "must be composed of key-value pairs in which the value is a hash which contains two keys, :am and :pm" do
      @nominal_understand_days.each do |k, v|
        v.length.must_equal 2
        v.has_key?(:am).must_equal true
        v.has_key?(:pm).must_equal true
      end
    end

    it "must contain a key-value pair for the start date in which the key is the start date, and the value is a 2-item hash, wherein the :am key's value is 'false' and the :pm key's value is 'true'" do

      start_date_am_pm_availability = @nominal_understand_days.assoc(@reservation_0_nominal_6n.start_date.jd.to_s)

      @nominal_understand_days.has_key?(@reservation_0_nominal_6n.start_date.jd.to_s).must_equal true
      start_date_am_pm_availability[1].length.must_equal 2
      start_date_am_pm_availability[1][:am].must_equal false
      start_date_am_pm_availability[1][:pm].must_equal true
    end


    it "must contain a key-value pair for the end date in which the key is the end date, and the value is a 2-item hash, wherein which the :am key's value is 'true' and the :pm key's value is 'false'" do

      end_date_am_pm_availability = @nominal_understand_days.assoc(@reservation_0_nominal_6n.end_date.jd.to_s)
      @nominal_understand_days.has_key?(@reservation_0_nominal_6n.end_date.jd.to_s).must_equal true
      # end_date_hash.count.must_equal 1
      end_date_am_pm_availability[1].length.must_equal 2
      end_date_am_pm_availability[1][:am].must_equal true
      end_date_am_pm_availability[1][:pm].must_equal false
    end

    it "must include a hash for each FULL DAY (i.e, non-starting or ending day) of the reservation, in which the values for :am and :pm are both 'true'" do

      test_copy_nominal_understand_1 = @nominal_understand_days.dup
      no_start_or_end_days = test_copy_nominal_understand_1.reject {|k, v| k == @reservation_0_nominal_6n.start_date.jd.to_s || k == @reservation_0_nominal_6n.end_date.jd.to_s}
      no_start_or_end_days.values.each {|value| value.each { |k, v| v.must_equal true}}
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
    it "correctly calculates the length of a stay that is one night long" do
      @reservation_1_1n.calculate_total_nights.must_equal 1
    end
  end

  describe "calculate_reservation_price" do
    it "returns a float rounded to two decimal places" do
      @reservation_0_nominal_6n.calculate_reservation_price.must_be_kind_of Float
      @reservation_0_nominal_6n.calculate_reservation_price.to_s.must_match /^\d+\.\d{1,2}$/
    end

    it "accurately returns the product of the room's per-day price and the length (in days) of the reservation" do
      @reservation_0_nominal_6n.calculate_reservation_price.must_be_within_delta 1200.00, 0.003
      @reservation_1_1n.calculate_reservation_price.must_be_within_delta 200.00, 0.003
      @reservation_3_35n.calculate_reservation_price.must_be_within_delta 7000.00, 0.003
    end
  end
end
