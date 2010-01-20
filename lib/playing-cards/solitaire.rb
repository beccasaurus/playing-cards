# ...
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
