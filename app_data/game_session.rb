# frozen_string_literal: true

# Some documentation:
# In order for game logic to work please provide player decision in String data type.
# If you wouldn't provide with data default player choice will be 'pass' in each round.

require_relative "deck"
require_relative "dealer"
require_relative "player"

class GameSession
  attr_accessor :round, :player, :deck, :dealer

  def initialize(name)
    @round = 0
    @player = Player.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start_round
    deck.cards = deck.fill_deck
    self.round += 1
    empty_hands
    money_to_bank
    2.times do
      fill_hand_for(player)
      fill_hand_for(dealer)
    end
  end

  # def fill_players_hands
  #   2.times do
  #     card = deck.give_card
  #     player.hand.take_card(card)
  #     dealer.hand.take_card(card)
  #   end
  # end

  # def empty_hands
  #   player.hand.withdraw_cards
  #   dealer.hand.withdraw_cards
  # end

  # def money_to_bank
  #   player.bank -= 10
  #   dealer.bank -= 10
  # end

  def play_round(player_decision)
    # Some method documentation:
    # returns array with round result in 'sym' (:victory, :defeat or :draw)
    # and game result in 'sym' (:game_won, :game_lost or :continue)
    choose_round_flow(player_decision.to_sym)
    round_result = calculate_match_results
    game_result = check_victory_conditions
    [round_result, game_result]
  end

  private

  def fill_hand_for(actor)
    card = deck.give_card
    actor.hand.take_card(card)
  end

  def empty_hands
    player.hand.withdraw_cards
    dealer.hand.withdraw_cards
  end

  def money_to_bank
    player.bank -= 10
    dealer.bank -= 10
  end

  def handle_ace_for(actor)
    return actor.points += 11 if actor.points < 11

    actor.points += 1
  end

  def choose_round_flow(player_decision)
    # Some method documentation:
    # Choice in case of wrong input is :pass
    return fill_hand_for(dealer) if dealer.hand.points < 17 && player_decision != :check

    fill_hand_for(player) if player_decision == :take
  end

  def calculate_match_results
    result = check_for_defeat
    result ||= check_for_victory
    result ||= check_for_draw
    result
  end

  # rubocop:disable Metrics/AbcSize
  def check_for_defeat
    if (points_of(player) > 21) ||
       ((points_of(dealer) > points_of(player)) &&
       points_of(dealer) <= 21)
      dealer.bank += 20
      :defeat
    end
  end

  def check_for_victory
    if (points_of(player) > points_of(dealer)) ||
       ((points_of(dealer) > points_of(player)) &&
                        points_of(dealer) > 21)
      player.bank += 20
      :victory
    end
  end
  # rubocop:enable Metrics/AbcSize

  def check_for_draw
    return unless points_of(dealer) == points_of(player)

    player.bank += 10
    dealer.bank += 10
    :draw
  end

  def check_victory_conditions
    return :game_won if dealer.bank <= 0
    return :game_lost if player.bank <= 0

    :continue
  end

  def points_of(actor)
    actor.hand.points
  end
end
