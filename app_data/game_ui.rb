# frozen_string_literal: true

require_relative "dealer"
require_relative "player"
require_relative "deck"
require_relative "game_session"

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/BlockLength
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
      loop do
        start_round(game_session, player, dealer, deck)
        puts "_______________________"
        puts "Round: #{game_session.round}"
        puts "_______________________"
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
            puts
            puts "Player bank: #{player.bank}"
            puts
            break
          when "pass"
            fill_hand_for(dealer, game_session, deck) if dealer.points < 17

            show_match_results(player, dealer)
            puts
            puts "Player bank: #{player.bank}"
            puts
            break
          when "check"
            show_match_results(player, dealer)
            puts
            puts "Player bank: #{player.bank}"
            puts
            break
          else
            puts "Wrong input. Please type in your choice again."
          end
        end

        if dealer.bank <= 0 || player.bank <= 0
          puts "You've won the game" if dealer.bank <= 0
          puts "You've completely lost" if player.bank <= 0
          break
        end

        puts "Press any key if you want to continue."
        puts "Press no if you want to exit the game."
        choice = gets.chomp
        break if choice == "no"
      end
    end

    private

    def start_round(game_session, player, dealer, deck)
      deck.cards = {}
      deck.fill_deck
      player.hand = []
      dealer.hand = []
      player.points = 0
      dealer.points = 0
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

    # rubocop:disable Style/GuardClause
    def show_match_results(player, dealer)
      show_player_stats(player)
      puts
      show_full_dealer_stats(dealer)
      if (player.points > 21) || ((dealer.points > player.points) && dealer.points <= 21)
        result ||= "You've lost the round"
        dealer.bank += 20
        puts
        puts result
        return result
      end

      if (player.points > dealer.points) || ((dealer.points > player.points) && dealer.points > 21)
        result ||= "You've won the round"
        player.bank += 20
        puts
        puts result
        return result
      end

      if dealer.points == player.points
        result ||= "This is draw"
        player.bank += 10
        dealer.bank += 10
        puts
        puts result
        return result
      end
    end
    # rubocop:enable Style/GuardClause

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
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/BlockLength
