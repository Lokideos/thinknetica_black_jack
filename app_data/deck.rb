# frozen_string_literal: true

class Deck
  attr_accessor :cards

  BASIC_CARDS = %w[2 3 4 5 6 7 8 9 10].freeze
  TEN_VALUE_CARDS = %w[J Q K].freeze
  LOWEST_VALUE = 2

  def initialize
    @cards = {}
    fill_deck
  end

  def fill_deck
    fill_deck_with_basic_cards
    fill_deck_with_ten_value_cards
    fill_deck_with_aces
  end

  def fill_deck_with_basic_cards
    card_value = LOWEST_VALUE

    BASIC_CARDS.each do |card|
      cards["|#{card}\u2660|"] = card_value
      cards["|#{card}\u2665|"] = card_value
      cards["|#{card}\u2663|"] = card_value
      cards["|#{card}\u2666|"] = card_value
      card_value += 1
    end
  end

  def fill_deck_with_ten_value_cards
    card_value = 10

    TEN_VALUE_CARDS.each do |card|
      cards["|#{card}\u2660|"] = card_value
      cards["|#{card}\u2665|"] = card_value
      cards["|#{card}\u2663|"] = card_value
      cards["|#{card}\u2666|"] = card_value
    end
  end

  def fill_deck_with_aces
    card_value = :a

    cards["|A\u2660|"] = card_value
    cards["|A\u2665|"] = card_value
    cards["|A\u2663|"] = card_value
    cards["|A\u2666|"] = card_value
  end

  def remove_card(card)
    cards.delete(card)
  end
end
