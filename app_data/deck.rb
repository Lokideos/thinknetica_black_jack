# frozen_string_literal: true

require_relative "card"

class Deck
  attr_accessor :cards

  SUITS = ["\u2660", "\u2665", "\u2663", "\u2666"].freeze
  RANKS_WITH_VALUES = [["2", 2], ["3", 3], ["4", 4], ["5", 5], ["6", 6], ["7", 7], ["8", 8],
                       ["9", 9], ["10", 10], ["J", 10], ["Q", 10], ["K", 10], ["A", :a]].freeze

  def initialize
    @cards = fill_deck
  end

  def remove_card(card)
    cards.delete(card)
  end

  def fill_deck
    RANKS_WITH_VALUES.each_with_object([]) do |rank, a|
      SUITS.each do |suit|
        a << Card.new(rank[0], suit, rank[1])
      end
    end.shuffle!
  end

  alias build_deck fill_deck
end
