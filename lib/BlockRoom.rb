

module Hotel
  class BlockRoom < Hotel::Room

    attr_reader :room_number, :base_resv_price, :min_res_sec, :rate_with_discount, :block_id, :block_start, :block_end

    attr_accessor :discount, :reservations, :dates_unavailable


    def initialize(room_number, block_id, discount, block_start, block_end)

      super(room_number)

      @room_number = room_number.concat("-B")
      @block_id = block_id
      @block_start = DateTime.parse(block_start)
      @block_end = DateTime.parse(block_end)
    end

  end
end
