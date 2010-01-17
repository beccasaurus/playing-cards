require 'forwardable'

# Misc playing card stuff

class Card

  STANDARD_PLAYING_CARD_NAMES  = %w( 2 3 4 5 6 7 8 9 10 Jack Queen King Ace )
  STANDARD_PLAYING_CARD_SUITES = %w( Spades Hearts Clubs Diamonds )

  attr_accessor :name, :suite

  def initialize name, suite = nil
    if suite.nil?
      parse(name)
    else
      self.name, self.suite = name, suite
    end
  end

  def name= value
    @name = value.to_s.strip.sub(/^The\s*/i, '')
  end

  def suite= value
    @suite = value.to_s.strip.downcase.sub(/s$/i, '')
  end

  def full_name
    "#{ name } of #{ suite.capitalize }s"
  end

  def self.[] name, suite = nil
    Card.new name, suite
  end

  def self.names
    STANDARD_PLAYING_CARD_NAMES
  end

  def self.suites
    STANDARD_PLAYING_CARD_SUITES
  end

  def == another_card
    another_card.name == name && another_card.suite == suite if another_card.is_a?(Card)
  end

private

  def parse name_to_parse
    name, suite = name_to_parse.split('of')
    self.name, self.suite = name, suite
  end

end

def Object.const_missing constant_name
  if constant_name.to_s =~ /(The)?(.+)of[spade|club|diamond|heart](s)?/i
    Card.new constant_name.to_s
  else
    super
  end
end

def Card name, suite = nil
  Card[name, suite]
end

class Deck
  extend Forwardable

  attr_accessor :cards

  def_delegators :cards, :first, :last, :length

  def initialize
    self.cards = Deck.cards_for_standard_52_deck
  end

  def self.cards_for_standard_52_deck
    cards = []

    Card.suites.each do |suite|
      Card.names.each do |name|
        cards << Card[name, suite]
      end
    end

    cards
  end

end
