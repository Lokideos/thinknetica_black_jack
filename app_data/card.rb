# frozen_string_literal: true

require_relative "support/validations"

class Card
  include Validations

  attr_accessor :rank, :suit
  attr_reader :value

  class << self
    SUITS = ["\u2660", "\u2665", "\u2663", "\u2666"].freeze
    RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

    def ranks
      RANKS
    end

    def suits
      SUITS
    end
  end

  RANK_FORMAT = /^[23456789JQKA]{1}$|^[1]{1}[0]{1}$/
  SUIT_FORMAT = /^[\u{2660}\u{2665}\u{2663}\u{2666}]{1}$/

  validate :rank, :presence
  validate :suit, :presence

  validate :rank, :format, RANK_FORMAT
  validate :suit, :format, SUIT_FORMAT

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = assign_value(rank)
    validate!
  end

  def assign_value(rank)
    value = 11
    value = rank.to_i unless rank.to_i.zero?
    value = 10 if rank.to_i.zero? && rank != "A"
    value
  end
end
