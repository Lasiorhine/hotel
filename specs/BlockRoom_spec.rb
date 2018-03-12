require 'date'
require 'pry'
require_relative 'spec_helper'

describe "BlockRoom class" do

  before do

    @basic_blockrm_1 = Hotel::BlockRoom.new("21", "3", 0.75, '12th March 4014', '20th March 4014')

  end

  describe "initialize(room_number, block_id, discount, block_start, block_end)" do

    it "can be initialized" do
      @basic_blockrm_1.must_be_instance_of Hotel::BlockRoom
    end


    it "has a @block_id variable that contains a number in string form" do

      @basic_blockrm_1.block_id.must_be_kind_of String
      @basic_blockrm_1.block_id.must_match /^\d+$/
    end
    it "has a @block_start variable that contains an instance of Ruby's date class " do

      @basic_blockrm_1.block_start.must_be_instance_of DateTime
    end

    it "has a @block_end variable that contains an instance of Ruby's date class " do

      @basic_blockrm_1.block_end.must_be_instance_of DateTime

    end


  end



end
