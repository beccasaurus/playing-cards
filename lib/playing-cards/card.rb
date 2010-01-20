# ...
def Card name, suite = nil
  Card[name, suite]
end

# Represents a playing card
class Card

  COLORS_FOR_SUITES = { 'club' => :black, 'spade' => :black, 'heart' => :red, 'diamond' => :red }
  NUMBERS_FOR_FACE_CARDS = { 'Ace' => 1, 'Jack' => 11, 'Queen' => 12, 'King' => 13 }

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

  def color
    Card.color_for(suite)
  end

  def to_i
    Card.number_for(name)
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

  def self.color_for suite
    COLORS_FOR_SUITES[suite]
  end

  def self.number_for name
    NUMBERS_FOR_FACE_CARDS[name] || name.to_i
  end

  def self.[] name, suite = nil
    return name if name.is_a?(Card)
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
    parts = name_to_parse.split('Of') if parts.length == 1

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
