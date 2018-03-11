require 'date'
require_relative 'spec_helper'

describe "FrontDesk class" do

  before do

    @front_desk_1 = Hotel::FrontDesk.new
    @front_desk_2 = Hotel::FrontDesk.new
    @front_desk_3 = Hotel::FrontDesk.new

    @room_1000_as = Hotel::Room.new("1000")
    @room_2000_bs = Hotel::Room.new("2000")
    @room_3000_cs = Hotel::Room.new("3000")
    @room_4000 = Hotel::Room.new("4000")
    @room_5000 = Hotel::Room.new("5000")
    @room_6000 = Hotel::Room.new("6000")
    @room_7000 = Hotel::Room.new("7000")

    @reservation_n1_a = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_n2_a = Hotel::Reservation.new('10th Jun 3014', '16th Jun 3014')
    @reservation_n3_a = Hotel::Reservation.new('10th Oct 3015', '9th Dec 3015')

    @reservation_n1_b = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_n2_b = Hotel::Reservation.new('10th Jun 3014', '16th Jun 3014')
    @reservation_n3_b = Hotel::Reservation.new('10th Oct 3015', '9th Dec 3015')

    @reservation_n1_c = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_n2_c = Hotel::Reservation.new('10th Jun 3014', '16th Jun 3014')
    @reservation_n3_c = Hotel::Reservation.new('10th Oct 3015', '9th Dec 3015')

    @reservation_n1_d = Hotel::Reservation.new('10th Jun 3013', '16th Jun 3013')
    @reservation_n2_d = Hotel::Reservation.new('10th Jun 3014', '16th Jun 3014')
    @reservation_n3_d = Hotel::Reservation.new('10th Oct 3015', '9th Dec 3015')

    @res_0_precede_n1_direct = Hotel::Reservation.new('5th Jun 3013', '10th Jun 3013')
    @res_1_fllws_n1_direct = Hotel::Reservation.new('16th Jun 3013', '2nd Jul 3013')
    @res_2_overlps_n1_begin = Hotel::Reservation.new('8th Jun 3013', '11th Jun 3013')
    @res_3_overlps_n1_end = Hotel::Reservation.new('15th Jun 3013', '5th Jul 3013')
    @res_4_overlps_n1_precede_n2 = Hotel::Reservation.new('14th Jun 3013', '10th Jun 3014')
    @res_5_fllws_n1_precedes_n2 = Hotel::Reservation.new('16th Jun 3013', '10th Jun 3014')
    @res_6_singleton = Hotel::Reservation.new('23rd Dec 3015', '3rd Jan 3016')

    @room_1000_as.add_reservation(@reservation_n1_a)
    @room_1000_as.add_reservation(@reservation_n2_a)
    @room_1000_as.add_reservation(@reservation_n3_a)

    @room_2000_bs.add_reservation(@reservation_n1_b)
    @room_2000_bs.add_reservation(@reservation_n2_b)
    @room_2000_bs.add_reservation(@reservation_n3_b)

    @rooms_w_nom_res = [@room_1000_as, @room_2000_bs]

    @front_desk_2.rooms = @rooms_w_nom_res


  end

  describe "initialize" do

    before do
      @front_desk_0 = Hotel::FrontDesk.new
    end

    it "can be initialized" do
      @front_desk_0.must_be_instance_of Hotel::FrontDesk
    end

    it "stores an array of instances of room in its @rooms_basic variable equal to the number of rooms in the hotel" do
      @front_desk_0.rooms.must_be_kind_of Array
      @front_desk_0.rooms.each {|element| element.must_be_instance_of Hotel::Room}
      @front_desk_0.rooms.count.must_equal 20
    end
  end

  describe "generate_rooms" do

    before do
      @test_rooms_1 = @front_desk_1.generate_rooms
    end

    it "creates a collection of instances of Room, which it stores in an array." do
      @test_rooms_1.must_be_kind_of Array
      @test_rooms_1.each {|element| element.must_be_instance_of Hotel::Room}
    end


    it "gives each room a unique room number, in the form of a string, going from 1 through the total number of rooms in the facility" do

      rooms_in_order = @test_rooms_1.sort_by {|room| room.room_number.to_i}
      rooms_in_order.length.must_equal 20
      rooms_in_order.each_with_index do |room, index|
        room.room_number.must_equal (index + 1).to_s
      end
    end
  end

  describe "report_all_rooms" do

    it "reports a complete list of all the rooms in the facility" do

      room_report = @front_desk_1.report_all_rooms.sort_by {|room| room.room_number.to_i}

      room_report.must_be_kind_of Array
      room_report.length.must_equal 20
      room_report.each_with_index do |room, index|
        room.room_number.must_equal (index + 1).to_s
      end
    end
  end

  describe "find_all_reservations_for_date(date)" do

    before do
      @room_1000_as.add_reservation(@res_1_fllws_n1_direct)
      @room_4000.add_reservation(@res_2_overlps_n1_begin)
      @room_5000.add_reservation(@res_5_fllws_n1_precedes_n2)
      @room_6000.add_reservation(@res_6_singleton)

      @front_desk_3.rooms = [@room_1000_as, @room_4000, @room_5000, @room_6000]
    end

    it "outputs a hash, where the keys are the numbers of reserved rooms, in string form, and the value of each is an array containing the id numbers of their reservations" do

      reservation_report_16_jun = @front_desk_3.find_all_reservations_for_date('16th Jun 3013')

      reservation_report_16_jun.must_be_kind_of Hash
      reservation_report_16_jun.count.must_equal 2

      reservation_report_16_jun.keys.must_include "1000"
      reservation_report_16_jun.keys.must_include "5000"

      reservation_report_16_jun.keys.wont_include "4000"
      reservation_report_16_jun.keys.wont_include "6000"

      reservation_report_16_jun["1000"].must_be_kind_of Array
      reservation_report_16_jun["1000"].must_include @reservation_n1_a.id
      reservation_report_16_jun["1000"].must_include @res_1_fllws_n1_direct.id

      reservation_report_16_jun["5000"].must_be_kind_of Array
      reservation_report_16_jun["5000"].must_include @res_5_fllws_n1_precedes_n2.id

    end

    it "returns an empty hash when there are no rooms reserved for a given day" do

      reservation_report_1_jan = @front_desk_3.find_all_reservations_for_date('1st  Jan 4047')

      reservation_report_1_jan.must_be_kind_of Hash
      reservation_report_1_jan.must_be_empty

    end
  end

  describe "report_all_available_rooms(start_dt, end_dt)" do

    # This method leverages availabiity-checking machinery that already exists in the Reservation class, and that machinery was already heavily tested by the Reservation spec, so it is just given a once-over here.

    before do

      @room_4000.add_reservation(@reservation_n1_d)
      @room_4000.add_reservation(@reservation_n2_d)
      @room_4000.add_reservation(@res_5_fllws_n1_precedes_n2)

      @room_5000.add_reservation(@reservation_n1_c)
      @room_5000.add_reservation(@res_1_fllws_n1_direct)


      @front_desk_3.rooms = [@room_1000_as, @room_2000_bs, @room_4000, @room_5000]

    end

    it "returns an array" do

      @front_desk_3.report_all_available_rooms("12 Jan 2099", "12 May 2099").must_be_kind_of Array

    end

    it "returns a collection of room numbers for the rooms available between specified dates" do

      aug_3013_rept =  @front_desk_3.report_all_available_rooms("1 Aug 3013", "17 Aug 3013")

      aug_3013_rept.count.must_equal 3

      aug_3013_rept.must_include "1000"
      aug_3013_rept.must_include "2000"
      aug_3013_rept.must_include "5000"

      aug_3013_rept.wont_include "4000"

    end

    it "returns an empty array if no rooms are available between specified dates" do

      @front_desk_3.report_all_available_rooms("12th Jun 3013", "14th Jun 3013").must_be_empty

    end

  end

  describe "find_available_room(start_d, end_d)" do

    before do

      @room_4000.add_reservation(@reservation_n1_d)
      @room_4000.add_reservation(@reservation_n2_d)
      @room_4000.add_reservation(@res_5_fllws_n1_precedes_n2)

      @room_5000.add_reservation(@reservation_n1_c)
      @room_5000.add_reservation(@res_1_fllws_n1_direct)

      @front_desk_3.rooms = [@room_1000_as, @room_4000, @room_5000]

    end

    it "returns the ID of a room that is available between specified dates in string form" do

      jun_19_jul_23_choice = @front_desk_3.find_available_room("19th Jun 2013", "23rd Jun 2013")

      jun_19_jul_23_choice.must_be_kind_of String
      jun_19_jul_23_choice.must_equal "1000"

    end

    it "if more than one room is available during a given interval, returns the room with the lowest room number" do

      @front_desk_3.find_available_room("12th Mar 3014", "21st Mar 3014").must_equal "1000"

      @front_desk_3.find_available_room("12th Nov 3015", "18th Nov 3015").must_equal "4000"

    end

    it "returns nil if no rooms are available between specified dates" do

      @front_desk_3.find_available_room("12th Jun 3013", "14th Jun 3013").must_be_nil

    end

  end

  describe "create_reservation_basic(start_date, end_date)" do

    before do

      @new_jan_3014_res = @front_desk_2.create_reservation_basic('2nd Jan 3014', '19th Jan 3014')

    end

    it "generates a reservation for a given date range" do

      @new_jan_3014_res.must_be_instance_of Hotel::Reservation
      @new_jan_3014_res.start_date.must_equal DateTime.parse('2nd Jan 3014')
      @new_jan_3014_res.end_date.must_equal DateTime.parse('19th Jan 3014')

    end

    it "assigns the reservation to a room that is available for that date range" do

      @new_jan_3014_res.hotel_room_id.must_equal "1000"

    end

    it "adds the reservation to the chosen room's collection" do

      @room_1000_as.reservations.must_include @new_jan_3014_res
    end

    it "assingns the reservation the correct per-night price for the room" do

      @new_jan_3014_res.per_night_price.must_be_within_delta 200.00, 0.001

    end

    it "raises an error if given an end-date that is earlier than its start date" do

      proc{ @front_desk_2.create_reservation_basic('19th Jan 3014','2nd Jan 3014')}.must_raise StandardError

    end

    it "raises an error if given start and and dates that are less than one night apart" do

      proc{ @front_desk_2.create_reservation_basic('19th Jan 3014','19th Jan 3014')}.must_raise StandardError

    end
  end

  # I think this is fully covered in the reservation class? But maybe there's a better way?

  xdescribe "report_reservation_price(id)" do
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
