# frozen_string_literal: true

class Card
  attr_accessor :rank, :suit, :value

  def initialize(rank, suit, value)
    @rank = rank
    @suit = suit
    @value = value
  end
end
