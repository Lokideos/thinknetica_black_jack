# frozen_string_literal: true

require_relative "support/cardable"

class Player
  include Cardable

  attr_accessor :bank, :hand, :name, :points

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
    @points = 0
  end
end
