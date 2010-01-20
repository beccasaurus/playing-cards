# ...
class Deck
  extend Forwardable

  attr_accessor :cards

  def_delegators :cards, :first, :last, :length, :empty?, :[], :[]=, 
                         :include?, :delete, :<<

  def initialize array_or_deck = nil
    self.cards = array_or_deck.is_a?(Deck) ? array_or_deck.cards : array_or_deck
    self.cards ||= []
  end

  def each &block
    cards.each(&block); self
  end

  def == value
    return false unless value.respond_to?(:length) and value.length == length
    return false unless value.respond_to?(:each)
    value.each do |card|
      return false unless include?(card)
    end
    return true
  end

  def remove card
    delete card
  end
  
  # a standard deck of cards
  def self.standard
    new(cards_for_standard_52_deck)
  end

  # an empty deck of cards
  def self.empty
    new
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

  def draw number_or_card = nil
    if number_or_card.nil?
      cards.delete_at(0)
    elsif number_or_card.is_a?(Card)
      delete number_or_card
    else
      drawn_cards = []
      number_or_card.times { drawn_cards << cards.delete_at(0) }
      Deck.new(drawn_cards)
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
