# frozen_string_literal: true

require_relative "support/cardable"
require_relative "support/validations"

class Player
  include Cardable
  include Validations

  validate :name, :presence
  validate :name, :type, String

  attr_accessor :bank, :hand, :name, :points

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
    @points = 0
    validate!
  end
end
