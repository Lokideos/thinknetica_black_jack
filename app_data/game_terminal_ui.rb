# frozen_string_literal: true

require_relative "player"
require_relative "game_session"

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/BlockLength
module GameTerminalUI
  class << self
    def show_menu
      puts
      puts "Let's start a new black jack game!"
      puts
      print "Please, type in your name: "
      name = gets.chomp
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
      game_session = GameSession.new(player)
      puts
      puts "Welcome to the game, #{game_session.player.name}!"
      puts
      loop do
        game_session.start_round
        show_round_counter(game_session)
        show_player_side(game_session)
        show_short_dealer_side(game_session)
        puts
        puts "Now choose your next action:"
        puts "Type in 'take' to take another card,"
        puts "type in 'pass' to pass round to the dealer"
        puts "or type in 'check' to check round results right now."
        puts
        choice = gets.chomp.downcase
        results = game_session.play_round(choice)
        puts
        show_player_side(game_session)
        show_full_dealer_side(game_session)
        puts
        puts "Congratulations! You've won the round!" if results.first == :victory
        puts "You've lost the round!" if results.first == :defeat
        puts "This is a Draw!" if results.first == :draw
        puts
        puts
        puts "Do you want to continue the game?"
        puts "If you don't want to continue the game type in 'no'."
        puts "Otherwise, press any key."
        choice = gets.chomp.downcase
        break if choice == "no"

        puts "You've win the whole game!" if results.last == :game_won
        puts "You've lost the whole game!" if results.last == :game_lost
        break unless results.last == :continue
      end
    end

    private

    # rubocop:disable Metrics/LineLength
    def show_round_counter(game_session)
      puts "_______________________"
      puts "Round: #{game_session.round}"
      puts "_______________________"
      puts
      puts
      puts
    end

    def show_player_side(game_session)
      puts
      puts "__________________________________________________________________________________________________________________"
      puts
      puts "                    #{game_session.player.name}                       "
      puts
      puts "                  YOUR BANK: #{game_session.player.bank}              "
      puts
      puts "                  YOUR SUM:  #{game_session.player.points}            "
      puts "______________________________________________________________________"
      puts
      puts "                 #{cards_of(game_session.player)}                     "
      puts
    end

    def show_short_dealer_side(game_session)
      puts
      puts "                 |*|     |*|                                          "
      puts
      puts "______________________________________________________________________"
      puts
      puts "                DEALER SUM: ??                                        "
      puts
      puts "                DEALER BANK: #{game_session.dealer.bank}              "
      puts
      puts "                  !!!DEALER!!!                                        "
      puts
      puts "__________________________________________________________________________________________________________________"
      puts
    end

    def show_full_dealer_side(game_session)
      puts
      puts "                 #{cards_of(game_session.dealer)}                     "
      puts
      puts "______________________________________________________________________"
      puts
      puts "                DEALER SUM:  #{game_session.dealer.points}            "
      puts
      puts "                DEALER BANK: #{game_session.dealer.bank}              "
      puts
      puts "                  !!!DEALER!!!                                        "
      puts
      puts "__________________________________________________________________________________________________________________"
      puts
    end

    def cards_of(actor)
      "#{first_card_of(actor)}     #{second_card_of(actor)}     #{third_card_of(actor)}"
    end

    def first_card_of(actor)
      "|#{actor.hand.first.rank}#{actor.hand.first.suit}|"
    end

    def second_card_of(actor)
      "|#{actor.hand[1].rank}#{actor.hand[1].suit}|"
    end

    def third_card_of(actor)
      "|#{actor.hand[2].rank}#{actor.hand[2].suit}|" if actor.hand[2]
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
