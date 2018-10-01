# frozen_string_literal: true

class Hand
  attr_accessor :cards, :points

  def initizlie
    @cards = []
    @points = 0
  end

  def take_card(card)
    cards << card
    card.value == 11 ? handle_ace : self.points += card.value
  end

  def withdraw_cards
    self.cards = []
    self.points = 0
  end

  private

  def handle_ace
    return self.points += 11 if points < 11

    self.points += 1
  end
end
