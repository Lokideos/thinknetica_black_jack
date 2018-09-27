# frozen_string_literal: true

class Player
  attr_accessor :bank, :hand, :name, :points

  def initialize(name)
    @name = name
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
