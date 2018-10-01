# frozen_string_literal: true

class Card
  attr_accessor :rank, :suit
  attr_reader :value

  class << self
    SUITS = ["\u2660", "\u2665", "\u2663", "\u2666"].freeze
    RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

    def ranks
      RANKS
    end

    def suits
      SUITS
    end
  end

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = assign_value(rank)
  end

  def assign_value(rank)
    value = 11
    value = rank.to_i if rank.to_i != 0
    value = 10 if rank.class.to_s == "String" && rank != "A"
    value
  end
end
