# frozen_string_literal: true

class GameSession
  attr_accessor :round, :turn

  def initialize
    @round = 1
    @turn = 1
  end
end
