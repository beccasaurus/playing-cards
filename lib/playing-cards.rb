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

  def short_name
    "#{ name[0..0].upcase }#{ suite[0..0].upcase }"
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

  def self.name_from_appreviation abbreviated_name
    name = abbreviated_name.to_s.downcase
    NAME_ABBREVIATIONS[name] || name
  end

  def self.suite_from_appreviation abbreviated_suite
    suite = abbreviated_suite.to_s.downcase
    SUITE_ABBREVIATIONS[suite] || suite
  end

private

  def parse name_to_parse
    parts = name_to_parse.split('of')

    # "Jack of Spades" or "The Jack of Spades"
    if parts.length == 2
      self.name, self.suite = parts.first, parts.last

    # "JS"
    elsif parts.length == 1 and parts.first.length == 2
      self.name  = Card.name_from_appreviation  parts.first[0..0]
      self.suite = Card.suite_from_appreviation parts.first[1..1]

    else
      raise "Not sure how to parse card: #{ name_to_parse.inspect }"
    end
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

  def add *cards
    if cards.length == 1
      if cards.first.is_a?(Card)
        self.cards << cards.first
      else
        cards.first.each {|card| self.cards << card } # assume array passed
      end
    else
      cards.each {|card| self.cards << card }
    end
  end

  def draw number = nil
    if number.nil?
      self.cards.delete_at(0)
    else
      drawn_cards = []
      number.times { drawn_cards << self.cards.delete_at(0) }
      drawn_cards
    end
  end

  def shuffle!
    the_cards = cards  # take the current cards and save them
    self.cards = []    # reset cards

    the_cards.length.times {
      # pick a card at random and add it to the cards
      self.cards << the_cards.delete_at(rand(the_cards.length))
    }
    
    self # return self so we can easily do Deck.new.shuffle!
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

class Solitaire

  attr_accessor :piles # the 7 main "piles"

  def initialize
    # take a new deck and sort it into the piles
    deck = Deck.new.shuffle!

    7.times do |pile_index|
      self.piles[pile_index] = []
      pile = self.piles[pile_index]

      # take cards from the deck and put them in the pile
      (i + 1).times do
        pile << deck.cards.take(1)
      end
    end
  end

end
