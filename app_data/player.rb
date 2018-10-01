# frozen_string_literal: true

# require_relative "support/cardable"
require_relative "support/validations"
require_relative "hand"

class Player
  # include Cardable
  include Validations

  validate :name, :presence
  validate :name, :type, String

  attr_accessor :bank, :hand, :name

  def initialize(name)
    @name = name
    @bank = 100
    @hand = Hand.new
    validate!
  end
end
