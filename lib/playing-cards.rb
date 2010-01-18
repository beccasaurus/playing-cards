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

  def_delegators :cards, :first, :last, :length, :empty?, :[], :[]=

  # TODO deprecate the use of Deck.new except for low-level 
  #      stuff ... Deck.standard should be used to get a standard deck!
  def initialize
    self.cards = Deck.cards_for_standard_52_deck
  end
  
  # a standard deck of cards
  def self.standard
    new
  end

  # an empty deck of cards
  def self.empty
    deck = new
    deck.cards = []
    deck
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

  def draw_all
    draw cards.length
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

  attr_accessor :waste # the cards we get to use from the draw pile

  attr_accessor :draw_pile # where we flip cards from

  def initialize
    # take a new deck and sort it into the piles
    deck = Deck.new.shuffle!

    # draw cards from the deck and use them to create the piles
    self.piles = []
    7.times do |i|
      piles << deck.draw(i + 1)
    end

    # set the deck to the 'draw_pile'
    self.draw_pile = deck
    self.waste     = Deck.empty
  end

  def inspect
    draw_game
  end

  def draw_on_to_waste number = 3
    if waste.length > 0
      draw_pile.add waste.draw_all # put the cards back in the draw pile
    end

    waste.add draw_pile.draw(number)

    self
  end

  alias waste! draw_on_to_waste

private

  def draw_game
    draw_title + draw_draw_pile_and_suite_piles + draw_piles
  end

  def draw_title
    "Solitaire\n\n"
  end

  def draw_draw_pile_and_suite_piles
    "#{ draw_draw_pile }    #{ draw_suite_piles }\n\n"
  end

  def draw_draw_pile
    if waste.empty?
      "[]         "
    else
      "[] #{ waste[0].short_name || '  ' } #{ waste[1].short_name || '  ' } #{ waste[2].short_name || '  ' }"
    end
  end

  def draw_suite_piles
    "[] [] [] []"
  end

  def draw_piles
    result = ''

    # get the biggest pile
    max_length = piles.inject(0){|max, pile| max = pile.length if pile.length > max; max }

    # go through the piles and add them to the string
    max_length.times do |i|
      piles.each do |pile|

        # if this is the last card of the pile, we show it, else we hide it
        if pile.length == (i + 1)
          result << pile[i].short_name
        elsif pile.length > (i + 1)
          result << '[]'
        else
          result << '  ' # place holder
        end

        result << '  ' # delimiter
      end
      result << "\n"
    end

    result
  end

end
