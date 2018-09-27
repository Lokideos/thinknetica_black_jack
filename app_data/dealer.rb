# frozen_string_literal: true

require_relative "support/cardable"

class Dealer
  include Cardable

  attr_accessor :bank, :hand, :points
  attr_reader :name

  def initialize
    @name = "Dealer"
    @bank = 100
    @hand = []
    @points = 0
  end
end
