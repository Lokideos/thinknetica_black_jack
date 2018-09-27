# frozen_string_literal: true

require_relative "dealer"
require_relative "player"
require_relative "deck"
require_relative "game_session"

game_session = GameSession.new
player = Player.new("LOKI")
dealer = Dealer.new
deck = Deck.new

# rubocop:disable Metrics/BlockLength
loop do
  2.times do
    card = deck.cards.keys[rand(deck.cards.keys.size)]
    player.take_card(card)
    if deck.cards[card] == :a
      game_session.handle_ace_for(player)
    else
      player.points += deck.cards[card]
    end
    deck.remove_card(card)

    card = deck.cards.keys[rand(deck.cards.keys.size)]
    dealer.take_card(card)
    if deck.cards[card] == :a
      game_session.handle_ace_for(dealer)
    else
      dealer.points += deck.cards[card]
    end
    deck.remove_card(card)
  end

  player.bank -= 10
  dealer.bank -= 10

  puts "Player hand: #{player.hand}"
  puts "Player.points: #{player.points}"
  puts "Player bank: #{player.bank}"
  puts "Dealer bank: #{dealer.bank}"

  game_session.round += 1

  puts "Do you want to take another card or try to win?"
  choice = gets.chomp

  case choice
  when "take"
    card = deck.cards.keys[rand(deck.cards.keys.size)]
    player.take_card(card)
    if deck.cards[card] == :a
      game_session.handle_ace_for(player)
    else
      player.points += deck.cards[card]
    end
    deck.remove_card(card)

    game_session.round += 1

    if dealer.points < 17
      card = deck.cards.keys[rand(deck.cards.keys.size)]
      dealer.take_card(card)
      if deck.cards[card] == :a
        game_session.handle_ace_for(dealer)
      else
        dealer.points += deck.cards[card]
      end
      deck.remove_card(card)

      game_session.round += 1
    end

    if game_session.round >= 3
      puts "Player hand: #{player.hand}"
      puts "Player.points: #{player.points}"
      puts "Dealer hand :#{dealer.hand}"
      puts "Dealer points: #{dealer.points}"
      result = "You lost it. (O_O)" if player.points > 21
      result ||= "You lost it. (O_O)" if dealer.points > player.points && dealer.points < 21
      result ||= "You win" if player.points > dealer.points
      result ||= "You win" if dealer.points > player.points && dealer.points > 21
    end
  when "win"
    puts "Player hand: #{player.hand}"
    puts "Player.points: #{player.points}"
    puts "Dealer hand :#{dealer.hand}"
    puts "Dealer points: #{dealer.points}"
    result = "You lost it. (O_O)" if player.points > 21
    result ||= "You lost it. (O_O)" if dealer.points > player.points && dealer.points < 21
    result ||= "You win" if player.points > dealer.points
    result ||= "You win" if dealer.points > player.points && dealer.points > 21
  else
    puts "dunno"
  end
  # rubocop:enable Metrics/BlockLength

  puts result
  break
end
