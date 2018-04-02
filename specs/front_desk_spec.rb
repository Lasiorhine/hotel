require 'date'
require 'pry'
require_relative 'spec_helper'

describe "FrontDesk class" do

  before do

    @front_desk_1 = Hotel::FrontDesk.new
    @front_desk_2 = Hotel::FrontDesk.new
    @front_desk_3 = Hotel::FrontDesk.new
    @front_desk_4 = Hotel::FrontDesk.new

    @room_1000_as = Hotel::Room.new("1000")
    @room_2000_bs = Hotel::Room.new("2000")
    @room_3000_cs = Hotel::Room.new("3000")
    @room_4000 = Hotel::Room.new("4000")
    @room_5000 = Hotel::Room.new("5000")
    @room_6000 = Hotel::Room.new("6000")
    @room_7000 = Hotel::Room.new("7000")
    @room_8000 = Hotel::Room.new("8000")

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

      @front_desk_0.rooms.each_with_index do |room, index|
        room.room_number.must_equal (index + 1).to_s
      end
    end

    it "has an instance variable, @blocks, which begins as an empty array" do


      @front_desk_0.blocks.must_be_kind_of Array

      @front_desk_0.blocks.must_be_empty

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


  # describe "find_all_reservations_for_date(date)" do
  #
  #   before do
  #     @room_1000_as.add_reservation(@res_1_fllws_n1_direct)
  #     @room_4000.add_reservation(@res_2_overlps_n1_begin)
  #     @room_5000.add_reservation(@res_5_fllws_n1_precedes_n2)
  #     @room_6000.add_reservation(@res_6_singleton)
  #
  #     @front_desk_3.rooms = [@room_1000_as, @room_4000, @room_5000, @room_6000]
  #   end
  #
  #   it "outputs a hash, where the keys are the numbers of reserved rooms, in string form, and the value of each is an array containing the id numbers of their reservations" do
  #
  #     reservation_report_16_jun = @front_desk_3.find_all_reservations_for_date('16th Jun 3013')
  #
  #     reservation_report_16_jun.must_be_kind_of Hash
  #     reservation_report_16_jun.count.must_equal 2
  #
  #     reservation_report_16_jun.keys.must_include "1000"
  #     reservation_report_16_jun.keys.must_include "5000"
  #
  #     reservation_report_16_jun.keys.wont_include "4000"
  #     reservation_report_16_jun.keys.wont_include "6000"
  #
  #     reservation_report_16_jun["1000"].must_be_kind_of Array
  #     reservation_report_16_jun["1000"].must_include @reservation_n1_a.id
  #     reservation_report_16_jun["1000"].must_include @res_1_fllws_n1_direct.id
  #
  #     reservation_report_16_jun["5000"].must_be_kind_of Array
  #     reservation_report_16_jun["5000"].must_include @res_5_fllws_n1_precedes_n2.id
  #
  #   end
  #
  #   it "returns an empty hash when there are no rooms reserved for a given day" do
  #
  #     reservation_report_1_jan = @front_desk_3.find_all_reservations_for_date('1st  Jan 4047')
  #
  #     reservation_report_1_jan.must_be_kind_of Hash
  #     reservation_report_1_jan.must_be_empty
  #
  #   end
  # end

  describe "report_overall_booking_status_for_date(date)" do

    before do
      @room_1000_as.add_reservation(@res_1_fllws_n1_direct)
      @room_4000.add_reservation(@res_2_overlps_n1_begin)
      @room_5000.add_reservation(@res_5_fllws_n1_precedes_n2)
      @room_6000.add_reservation(@res_6_singleton)

      @front_desk_3.rooms = [@room_1000_as, @room_4000, @room_5000, @room_6000]

      reservation_report_16_jun = @front_desk_3.report_overall_booking_status_for_date('16th Jun 3013')

    end

    it "outputs a hash, where the keys are the numbers of all the hotel's rooms, in string form" do

      reservation_report_16_jun = @front_desk_3.find_all_reservations_for_date('16th Jun 3013')

      reservation_report_16_jun.must_be_kind_of Hash
      reservation_report_16_jun.length.must_equal 4

      reservation_report_16_jun.keys.must_include "1000"
      reservation_report_16_jun.keys.must_include "5000"
      reservation_report_16_jun.keys.must_include "4000"
      reservation_report_16_jun.keys.must_include "6000"

      reservation_report_16_jun.keys.wont_include "2"
      reservation_report_16_jun.keys.wont_include "2000"

    end

    it "outputs a hash where the value of each key is a hash containing two key-value pairs, one with a key of :am, and one with a key of :pm, which have values of either true or false depending on the room's reservation status" do

      reservation_report_16_jun["1000"].must_be_kind_of Hash
      reservation_report_16_jun["1000"].length.must_equal 2
      reservation_report_16_jun["1000"].keys.must_include :am
      reservation_report_16_jun["1000"].keys.must_include :pm

      reservation_report_16_jun.dig("1000", :am).must_equal true
      reservation_report_16_jun.dig("1000", :pm).must_equal true

      reservation_report_16_jun["5000"].must_be_kind_of Hash
      reservation_report_16_jun["5000"].length.must_equal 2
      reservation_report_16_jun["5000"].keys.must_include :am
      reservation_report_16_jun["5000"].keys.must_include :pm
      reservation_report_16_jun.dig("5000", :am).must_equal false
      reservation_report_16_jun.dig("5000", :pm).must_equal true

    end

    it "For a room with no bookings on a given date, it returns a hash with the room's number as the key, and the string 'no bookings' as the value." do

      reservation_report_16_jun["4000"].must_be_kind_of Hash
      reservation_report_16_jun["4000"].length.must_equal 1
      reservation_report_16_jun["4000"].must_equal "no bookings"
      reservation_report_16_jun["4000"].keys.wont_include :am
      reservation_report_16_jun["4000"].keys.wont_include :pm

    end

  end





  describe "report_all_available_rooms(start_dt, end_dt, room_set)" do

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

      @front_desk_3.report_all_available_rooms("12 Jan 2099", "12 May 2099", @front_desk_3.rooms).must_be_kind_of Array

    end

    it "returns a collection of room numbers for the rooms available between specified dates" do

      aug_3013_rept =  @front_desk_3.report_all_available_rooms("1 Aug 3013", "17 Aug 3013", @front_desk_3.rooms)

      aug_3013_rept.count.must_equal 3

      aug_3013_rept.must_include "1000"
      aug_3013_rept.must_include "2000"
      aug_3013_rept.must_include "5000"

      aug_3013_rept.wont_include "4000"

    end

    it "returns an empty array if no rooms are available between specified dates" do

      @front_desk_3.report_all_available_rooms("12th Jun 3013", "14th Jun 3013", @front_desk_3.rooms).must_be_empty

    end

  end

  describe "find_available_room(start_d, end_d, room_set)" do

    before do

      @room_4000.add_reservation(@reservation_n1_d)
      @room_4000.add_reservation(@reservation_n2_d)
      @room_4000.add_reservation(@res_5_fllws_n1_precedes_n2)

      @room_5000.add_reservation(@reservation_n1_c)
      @room_5000.add_reservation(@res_1_fllws_n1_direct)

      @front_desk_3.rooms = [@room_1000_as, @room_4000, @room_5000]

    end

    it "returns the ID of a room that is available between specified dates in string form" do

      jun_19_jul_23_choice = @front_desk_3.find_available_room("19th Jun 2013", "23rd Jun 2013", @front_desk_3.rooms)

      jun_19_jul_23_choice.must_be_kind_of String
      jun_19_jul_23_choice.must_equal "1000"

    end

    it "if more than one room is available during a given interval, returns the room with the lowest room number" do

      @front_desk_3.find_available_room("12th Mar 3014", "21st Mar 3014", @front_desk_3.rooms).must_equal "1000"

      @front_desk_3.find_available_room("12th Nov 3015", "18th Nov 3015", @front_desk_3.rooms).must_equal "4000"

    end

    it "returns nil if no rooms are available between specified dates" do

      @front_desk_3.find_available_room("12th Jun 3013", "14th Jun 3013", @front_desk_3.rooms).must_be_nil

    end

  end

  describe "create_reservation_basic(start_date, end_date, room_set)" do

    before do
      @new_jan_3014_res = @front_desk_2.create_reservation_basic('2nd Jan 3014', '19th Jan 3014', @front_desk_2.rooms)
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

    it "raises an error if no rooms are available in the desired date range." do
      proc{ @front_desk_2.create_reservation_basic('11th Jun 3013','13th Jun 3013', @front_desk_2.rooms)}.must_raise StandardError
    end
  end


  describe "look_up_per_night_price_for_room(query_room_numb)" do

    before do
      @rm_1000_price = @front_desk_2.look_up_per_night_price_for_room("1000")
    end

    it "returns a float" do
      @rm_1000_price.must_be_kind_of Float
    end

    it "correctly identifies the price per night for a given hotel room" do

      @rm_1000_price.must_be_within_delta 200.00, 0.003

    end
  end

  describe "locate_room_by_id(query_rm_numb)" do

    before do
      @rm_2000_object= @front_desk_2.locate_room_by_id("2000")
    end

    it "returns an instance of Hotel::Room" do
      @rm_2000_object.must_be_instance_of Hotel::Room
    end

    it "identifies the correct instance of Room." do

      @rm_2000_object.must_be_same_as @room_2000_bs

    end
  end

  describe "report_reservation_price(id)" do

    before do
      @room_6000.add_reservation(@reservation_n1_c)
      @room_6000.add_reservation(@res_6_singleton)

      @front_desk_3.rooms = [@room_1000_as, @room_6000, @room_2000_bs]

      @res_price_query_id = @res_6_singleton.id

      @reported_price = @front_desk_3.find_reservation_price(@res_price_query_id)
    end

    it "identifies returns a float" do
      @reported_price.must_be_kind_of Float
    end

    it "correctly reports the price of a reservation" do
      @reported_price.must_be_within_delta 2200.00, 0.003
    end

    it "returns nil if the reservation id does not exist" do
      @front_desk_3.find_reservation_price("1111111111111").must_be_nil
    end
  end


  describe "check_block_feasibility(st_dt, end_dt, room_set, block_size)" do

    before do

      @room_3000_cs.add_reservation(@reservation_n1_c)
      @room_3000_cs.add_reservation(@reservation_n2_c)
      @room_3000_cs.add_reservation(@reservation_n3_c)

      @three_rooms_identical_avail = [@room_1000_as, @room_2000_bs, @room_3000_cs]

      @front_desk_3.rooms = @three_rooms_identical_avail

      @three_ident_feasible = @front_desk_3.check_block_feasibility('1st Mar 3015', '10th Mar 3015',@front_desk_3.rooms, 3)


      @three_ident_infeas = @front_desk_3.check_block_feasibility('1st Nov 3015', '10th Nov 3015', @front_desk_3.rooms, 3)

    end

    it "returns a hash containing a single key-value pair, whether a block of rooms is available or not." do

      @three_ident_feasible.must_be_kind_of Hash
      @three_ident_infeas.must_be_kind_of Hash

      @three_ident_feasible.count.must_equal 1
      @three_ident_infeas.count.must_equal 1

    end

    it "has a key with the value :yes when rooms are available for the block" do

      @three_ident_feasible.keys.must_include :yes

    end

    it "has a key with the value :no when not enough rooms are available for the block" do

      @three_ident_infeas.keys.must_include :no

    end

    it "when rooms are available for the block, returns a key-value where the value is an array of the room numbers of available rooms" do

      @three_ident_feasible[:yes].must_be_kind_of Array
      @three_ident_feasible[:yes].each {|element| element.must_be_kind_of String}
      @three_ident_feasible[:yes].each {|element| element.must_match /^\d+$/ }

    end

    it "accurately reports the room numbers of rooms available for the block" do

      @three_ident_feasible[:yes].length.must_equal 3
      @three_ident_feasible[:yes].must_include "1000"
      @three_ident_feasible[:yes].must_include "2000"
      @three_ident_feasible[:yes].must_include "3000"
    end

    it "returns a key-value pair with an empty array as the value if not enough rooms are available for the block" do

      @three_ident_infeas[:no].must_be_kind_of Array
      @three_ident_infeas[:no].must_be_empty

    end
  end

  describe "create_block_placeholder_res(start_date, end_date, room_id, block_id)" do


    before do


      @placeholder_reservation = @front_desk_4.create_placeholder_res('12th Jan 2099', '19th Jan 2099', '7000', '8')


    end

    it "is an instance of Reservation" do

      @placeholder_reservation.must_be_instance_of Hotel::Reservation

    end

    it "has a start date and an end date that are instances of Ruby's DateTime class" do

      @placeholder_reservation.start_date.must_be_instance_of DateTime
      @placeholder_reservation.end_date.must_be_instance_of DateTime

    end

    it "has a value of true for its @block_set_aside instance variable" do

      @placeholder_reservation.block_set_aside.must_equal true

    end

    it "has a @block_id variable that takes a number in string form as its value" do

      @placeholder_reservation.block_id.must_be_kind_of String
      @placeholder_reservation.block_id.must_match /^\d+$/

    end
  end
  describe "create_room_block(st_date, end_date, block_size, room_set, block_discount)" do

    before do
      @room_3000_cs.add_reservation(@reservation_n1_c)
      @room_3000_cs.add_reservation(@reservation_n2_c)
      @room_3000_cs.add_reservation(@reservation_n3_c)

      @three_rooms_identical_avail = [@room_1000_as, @room_2000_bs, @room_3000_cs]

      @front_desk_3.rooms = @three_rooms_identical_avail

      @valid_block = @front_desk_3.create_room_block('1st Mar 3015', '10th Mar 3015', 3, @front_desk_3.rooms, 0.2)


    end

    it "returns a hash exactly one key-value pair long, when enough rooms are available for the reservation" do

      @valid_block.must_be_kind_of Hash
      @valid_block.count.must_equal 1

    end

    it "Raises a StandardError when there are not enough rooms available for the block" do

      proc{ @front_desk_3.create_room_block('1st Nov 3015', '10th Nov 3015', 3)}.must_raise StandardError

    end

    it "has a key that is a procedurally generated block id number in symbol look_up_per_night_price_for_room" do

      @valid_block.keys.length.must_equal 1
      @valid_block.keys[0].must_be_kind_of Symbol
      @valid_block.keys[0].to_s.must_match /^\d+$/

    end

    it "has as its value an array of instances of BlockRoom" do

      @valid_block.values.length.must_equal 1
      @valid_block.values[0].must_be_kind_of Array
      @valid_block.values[0].each {|element| element.must_be_instance_of Hotel::BlockRoom}

    end

    it "has one instance of BlockRoom for every room in the block" do
      @valid_block.values[0].length.must_equal 3
    end

    it "stores the blocks in FrontDesk's @blocks array" do
      @front_desk_3.blocks.must_include @valid_block
    end

    it "marks the dates of the block as unavailable in the room's dates_unavailable hash" do

      @room_3000_cs.dates_unavailable.keys.must_include "2822333"
      @room_2000_bs.dates_unavailable.keys.must_include "2822332"
      @room_1000_as.dates_unavailable.keys.must_include "2822329"
    end
  end
  describe "check_availability_within_block(start_date, end_date, block_id)" do
    before do
      @room_3000_cs.add_reservation(@reservation_n1_c)
      @room_3000_cs.add_reservation(@reservation_n2_c)
      @room_3000_cs.add_reservation(@reservation_n3_c)

      @three_rooms_identical_avail = [@room_1000_as, @room_2000_bs, @room_3000_cs]

      @front_desk_3.rooms = @three_rooms_identical_avail

      @valid_block = @front_desk_3.create_room_block('1st Mar 3015', '10th Mar 3015', 3, @front_desk_3.rooms, 0.2)
      @valid_blocK_id = @valid_block.keys[0]

      @block_search_result = @front_desk_3.check_availability_within_block('3rd Mar 3015', '7th Mar 3015', @valid_blocK_id)
    end

    it "returns an array" do
      @block_search_result.must_be_kind_of Array
    end

    it 'returns a collection of room numbers for the rooms available between the specified dates' do

      @block_search_result.must_include "1000-B"
      @block_search_result.must_include "2000-B"
      @block_search_result.must_include "3000-B"

    end

    it 'returns an empty array if no rooms are available between the specified dates' do

      # COME BACK TO THIS AFTER YOU HAVE RESERVATION ADD WORKING
    end
  end

  xdescribe "create_reservation_within_block(start_date, end_date, block_id)" do

    #NOTES:  THIS IS WHERE THE WHEELS FELL OFF FOR ME.  I GOT ALMOST ALL THE WAY THROUGH, BUT EXHAUSTION FINALLY WON.


    before do
      @room_3000_cs.add_reservation(@reservation_n1_c)
      @room_3000_cs.add_reservation(@reservation_n2_c)
      @room_3000_cs.add_reservation(@reservation_n3_c)

      @three_rooms_identical_avail = [@room_1000_as, @room_2000_bs, @room_3000_cs]

      @front_desk_3.rooms = @three_rooms_identical_avail

      @valid_block = @front_desk_3.create_room_block('1st Mar 3015', '10th Mar 3015', 3, @front_desk_3.rooms, 0.2)

      @valid_block_id = @valid_block.keys[0]

      @block_reservation_req_result = @front_desk_3.create_reservation_within_block('4th Mar 3015', '7th Mar 3015', @valid_block_id)
    end

    it "returns an instance of Hotel::Reservation" do


      @block_reservation_req_result.must_be_instance_of Hotel::Reservation

    end
  end
end
