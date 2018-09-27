# frozen_string_literal: true

class Dealer
  attr_accessor :bank, :hand, :points
  attr_reader :name

  def initialize
    @name = "Dealer"
    @bank = 100
    @hand = []
    @points = 0
  end

  def take_card(card)
    @hand << card
  end

  def empty_hand
    @hand = []
  end
end
