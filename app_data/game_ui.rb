# frozen_string_literal: true

require_relative "dealer"
require_relative "player"
require_relative "deck"
require_relative "game_session"

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
module GameUI
  class << self
    def show_menu
      puts
      puts "Let's start a new black jack game!"
      puts
      print "Please, type in your name: "
      name = gets.chomp
      game_session = GameSession.new
      player = Player.new(name)
      dealer = Dealer.new
      deck = Deck.new
      puts
      puts "Welcome to the game, #{player.name}!"
      puts
      start_round(game_session, player, dealer, deck)
      show_player_stats(player)
      puts
      show_short_dealer_stats(dealer)
      puts
      puts "You can take another card, pass or try to win now."
      loop do
        puts "Type in 'take' to take card, 'pass', to pass or 'check' to finish this turn."
        choice = gets.chomp
        case choice
        when "take"
          fill_hand_for(player, game_session, deck)

          fill_hand_for(dealer, game_session, deck) if dealer.points < 17

          show_match_results(player, dealer)
          break
        when "pass"
          fill_hand_for(dealer, game_session, deck) if dealer.points < 17

          show_match_results(player, dealer)
        when "check"
          show_match_results(player, dealer)
          break
        else
          puts "Wrong input. Please type in your choice again."
        end
      end
    end

    private

    def start_round(game_session, player, dealer, deck)
      player.bank -= 10
      dealer.bank -= 10
      game_session.round += 1

      2.times do
        fill_hand_for(player, game_session, deck)
        fill_hand_for(dealer, game_session, deck)
      end
    end

    def fill_hand_for(actor, game_session, deck)
      card = deck.cards.keys[rand(deck.cards.keys.size)]
      actor.take_card(card)
      if deck.cards[card] == :a
        game_session.handle_ace_for(actor)
      else
        actor.points += deck.cards[card]
      end
      deck.remove_card(card)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def show_match_results(player, dealer)
      show_player_stats(player)
      puts
      show_full_dealer_stats(dealer)
      result = "You lost it. (O_O)" if player.points > 21
      result ||= "You lost it. (O_O)" if dealer.points > player.points && dealer.points <= 21
      result ||= "You win" if player.points > dealer.points
      result ||= "You win" if dealer.points > player.points && dealer.points > 21
      result ||= "This is draw" if dealer.points == player.points
      puts
      puts result
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def show_player_stats(player)
      puts "Player hand: #{player.hand}"
      puts "Player points: #{player.points}"
      puts "Player bank: #{player.bank}"
    end

    def show_short_dealer_stats(dealer)
      puts "Dealer bank: #{dealer.bank}"
    end

    def show_full_dealer_stats(dealer)
      puts "Dealer hand: #{dealer.hand}"
      puts "Dealer points: #{dealer.points}"
      puts "Dealer bank: #{dealer.bank}"
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
