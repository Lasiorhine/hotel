require 'date'

require_relative 'reservation'
require_relative 'front_desk'

module Hotel
  class Room
    attr_reader :room_number
    attr_accessor :reservations :dates_unavailable

    def initialize(room_number)
      @room_number = :room_number
      @reservations = []
      @dates_unavailable = []
    end
  end
end
