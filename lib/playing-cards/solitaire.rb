# ...
class Solitaire

  module CardExtensions
    attr_accessor :is_visible

    def is_visible
      @is_visible = true if @is_visible.nil? # default to true
      @is_visible
    end

    def visible?
      is_visible == true
    end

    def hidden?
      ! visible?
    end

    def hide!
      self.is_visible = false
    end

    def show!
      self.is_visible = true
    end

    # incase we want to override how names are printed
    def draw_name
      short_name
    end
  end

  attr_accessor :piles # the 7 main "piles"

  attr_accessor :waste # the cards we get to use from the draw pile

  attr_accessor :draw_pile # where we flip cards from

  attr_accessor :suite_piles

  def initialize
    # take a new deck and sort it into the piles
    deck = Deck.standard.shuffle!

    # draw cards from the deck and use them to create the piles
    self.piles = []
    7.times do |i|
      piles << deck.draw(i + 1).each {|card| card.hide! }
    end

    self.suite_piles = { 'heart' => Deck.empty, 'club'    => Deck.empty,
                         'spade' => Deck.empty, 'diamond' => Deck.empty }

    # show the top card of each pile
    piles.each {|pile| pile.last.show! }

    # set the deck to the 'draw_pile'
    self.draw_pile = deck
    self.waste     = Deck.empty
  end

  def inspect
    draw_game
  end

  # this only affects piles right now
  def move card, onto_this_card = nil
    return smart_move(card) if onto_this_card.nil?

    card, onto_this_card = Card(card), Card(onto_this_card)

    pile = pile_that_card_is_at_the_top_of(onto_this_card)
    if pile
      if waste.last != card
        raise "#{ card.full_name } is not available to be moved"
      elsif card.to_i != (onto_this_card.to_i - 1)
        raise "Cards must be sequential"
      elsif card.color == onto_this_card.color
        raise "Cards cannot be placed onto cards of the same color"
      else
        pile.add waste.draw(card)
      end
    else
      raise "Hmm ... where is #{ onto_this_card.full_name }?"
    end

    self
  end

  # only handles waste for now
  def smart_move card
    card = Card(card)

    raise "#{ card.full_name } is not available to be moved" if waste.last != card

    # check suite pile
    if suite_piles[card.suite].empty?
      if card.name == 'Ace'
        suite_piles[card.suite].add waste.draw(card)
      end
    else
      if suite_piles[card.suite].last.to_i == (card.to_i - 1)
        suite_piles[card.suite].add waste.draw(card)
      end
    end

    self
  end

  def pile_that_card_is_at_the_top_of card
    piles.detect {|pile| pile.last == card }
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
      text = "[] "
      3.times do |i|
        text << (waste[i] ? waste[i].draw_name : '  ')
        text << ' '
      end
      text
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
        if pile[i]
          result << (pile[i].visible? ? pile[i].draw_name : '[]')
        else
          result << '  '
        end
        result << '  ' # delimiter
      end
      result << "\n"
    end

    result
  end

end

Card.send :include, Solitaire::CardExtensions
