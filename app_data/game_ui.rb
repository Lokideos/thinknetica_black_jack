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
      begin
        player = Player.new(name)
      rescue RuntimeError => e
        puts
        puts "There was en error: #{e.message}"
        puts "You didn't provide correct name."
        puts "Therefore, your name will be called HACKERMAN."
        name = "HACKERMAN"
        player = Player.new(name)
      end
      dealer = Dealer.new
      deck = Deck.new
      puts
      puts "Welcome to the game, #{player.name}!"
      puts
      loop do
        start_round(game_session, player, dealer, deck)
        show_round_counter(game_session)
        show_player_side(player)
        show_dealer_side(dealer)
        puts
        puts "You can take another card, pass or try to win now."
        loop do
          puts "Type in 'take' to take card, 'pass', to pass or 'check' to finish this turn."
          choice = gets.chomp.downcase
          case choice
          when "take"
            fill_hand_for(player, game_session, deck)
            fill_hand_for(dealer, game_session, deck) if dealer.points < 17

            show_player_side(player)
            show_dealer_side(dealer)
            show_match_results(player, dealer)
            break
          when "pass"
            fill_hand_for(dealer, game_session, deck) if dealer.points < 17

            show_player_side(player)
            show_dealer_side(dealer)
            show_match_results(player, dealer)
            break
          when "check"
            show_match_results(player, dealer)

            show_player_side(player)
            show_dealer_side(dealer)
            break
          else
            puts "WRONG LITTLE LETTERS! TRY AGAIN!!!"
          end
        end

        if dealer.bank <= 0 || player.bank <= 0
          puts "!!!CONGRATULATIONS! YOU HAVE WON THE GAME!!!" if dealer.bank <= 0
          puts "!!!CONGRATULATIONS!!! YOU HAVE COMPLETELE LOST!!!" if player.bank <= 0
          break
        end

        puts "!!!PRESS ANYTHING TO CONTINUE!!!"
        puts
        puts "In case that you don't want to continue to play in this amazing game,"
        puts "type in 'no' and press enter."
        choice = gets.chomp.downcase
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
      if (player.points > 21) || ((dealer.points > player.points) && dealer.points <= 21)
        result ||= "!!!YOU HAVE LOST THE ROUND!!!"
        dealer.bank += 20
        puts
        puts result
        puts
        return result
      end

      if (player.points > dealer.points) || ((dealer.points > player.points) && dealer.points > 21)
        result ||= "!!!YOU HAVE WON THE ROUND!!!"
        player.bank += 20
        puts
        puts result
        puts
        return result
      end

      if dealer.points == player.points
        result ||= "!!!OH!!!THIS IS DRAW!!!OH!!!"
        player.bank += 10
        dealer.bank += 10
        puts
        puts result
        puts
      end
    end
    # rubocop:enable Style/GuardClause

    # rubocop:disable Metrics/LineLength
    def show_round_counter(game_session)
      puts "_______________________"
      puts "Round: #{game_session.round}"
      puts "_______________________"
      puts
      puts
      puts
    end

    def show_player_side(player)
      puts
      puts "__________________________________________________________________________________________________________________"
      puts
      puts "                    #{player.name}                       "
      puts
      puts "                  YOUR BANK: #{player.bank}              "
      puts
      puts "                  YOUR SUM:  #{player.points}            "
      puts "_________________________________________________________"
      puts
      puts "                 #{player.hand.first}     #{player.hand[1]}     #{player.hand[2]}"
      puts
    end

    def show_dealer_side(dealer)
      puts
      puts "                 #{dealer.hand.first}     #{dealer.hand[1]}     #{dealer.hand[2]}"
      puts
      puts "_________________________________________________________"
      puts
      puts "                DEALER SUM:  #{dealer.points}            "
      puts
      puts "                DEALER BANK: #{dealer.bank}              "
      puts
      puts "                  !!!DEALER!!!                           "
      puts
      puts "__________________________________________________________________________________________________________________"
      puts
    end
    # rubocop:enable Metrics/LineLength
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/BlockLength
