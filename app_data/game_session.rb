# frozen_string_literal: true

class GameSession
  attr_accessor :round, :turn

  def initialize
    @round = 1
    @turn = 1
  end

  def handle_ace_for(actor)
    return actor.points += 11 if actor.points < 11

    actor.points += 1
  end
end
