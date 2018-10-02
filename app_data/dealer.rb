# frozen_string_literal: true

# require_relative "support/cardable"
require_relative "hand"

class Dealer
  # include Cardable

  attr_accessor :bank, :hand
  attr_reader :name

  def initialize
    @name = "Dealer"
    @bank = 100
    @hand = Hand.new
    @points = 0
  end
end
