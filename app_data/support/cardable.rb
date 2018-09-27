# frozen_string_literal: true

# Sometimes following ruby naming convention is really weird.

module Cardable
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def take_card(card)
      hand << card
    end

    def empty_hand
      self.hand = []
    end
  end
end
