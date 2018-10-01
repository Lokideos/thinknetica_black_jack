# frozen_string_literal: true

require_relative "card"

class Deck
  attr_accessor :cards

  def initialize; end

  def remove_card(card)
    cards.delete(card)
  end

  def fill_deck
    Card.ranks.each_with_object([]) do |rank, a|
      Card.suits.each do |suit|
        a << Card.new(rank, suit)
      end
    end.shuffle!
  end

  alias build_deck fill_deck
end
