# ...
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
