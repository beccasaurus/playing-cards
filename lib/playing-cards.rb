require 'forwardable'

# Misc playing card stuff

class Card

  STANDARD_PLAYING_CARD_NAMES  = %w( 2 3 4 5 6 7 8 9 10 Jack Queen King Ace )
  STANDARD_PLAYING_CARD_SUITES = %w( Spades Hearts Clubs Diamonds )

  NAME_ABBREVIATIONS  = { 'j' => 'Jack', 'q' => 'Queen', 'k' => 'King', 'a' => 'Ace' }
  SUITE_ABBREVIATIONS = { 's' => 'spade', 'h' => 'heart', 'c' => 'club', 'd' => 'diamond' }

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
    parts = name_to_parse.split('of')

    # "Jack of Spades" or "The Jack of Spades"
    if parts.length == 2
      self.name, self.suite = parts.first, parts.last

    # "JS"
    elsif parts.length == 1 and parts.first.length == 2
      self.name  = name_from_appreviation  parts.first[0..0]
      self.suite = suite_from_appreviation parts.first[1..1]

    else
      raise "Not sure how to parse card: #{ name_to_parse.inspect }"
    end
  end

  def name_from_appreviation abbreviated_name
    name = abbreviated_name.to_s.downcase
    NAME_ABBREVIATIONS[name] || name
  end

  def suite_from_appreviation abbreviated_suite
    suite = abbreviated_suite.to_s.downcase
    SUITE_ABBREVIATIONS[suite] || suite
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
