# frozen_string_literal: true

require_relative "game_ui"

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
module MainUI
  MENU_OPTIONS = {
    1 => "NEW GAME",
    2 => "OPTIONS",
    3 => "CREDITS",
    4 => "EXIT"
  }.freeze

  class << self
    def show_menu
      puts
      puts "Welcome to Thinknetica Blackjack Game!"
      puts

      loop do
        puts
        MENU_OPTIONS.each do |option, value|
          puts "#{option}: #{value}"
        end

        puts
        puts "Please select option to continue."

        choice = gets.chomp.to_i
        case choice
        when 1
          puts
          GameUI.show_menu
        when 2
          puts
          puts "No options here."
        when 3
          puts
          puts "All credits go to Thinknetica."
        when 4
          break
        else
          puts
          puts "No such option in main menu."
        end
        # break if choice == 4
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
