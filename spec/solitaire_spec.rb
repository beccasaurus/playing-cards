require File.dirname(__FILE__) + '/spec_helper'

# http://en.wikipedia.org/wiki/Solitaire_terminology

describe Solitaire do

  it 'new game should have 7 piles' do
    game = Solitaire.new

    game.piles.length.should == 7
    game.piles[0].length.should == 1
    game.piles[1].length.should == 2
    game.piles[2].length.should == 3
    game.piles[3].length.should == 4
    game.piles[4].length.should == 5
    game.piles[5].length.should == 6
    game.piles[6].length.should == 7
  end

  it 'should be able to #inspect the game and see it all pretty' do
    game = Solitaire.new

    game.piles[1].length.should == 2
    hidden  = game.piles[1].first
    visible = game.piles[1].last

    game.inspect.should_not include(hidden.short_name)
    game.inspect.should     include(visible.short_name)
  end

  it 'should have a draw pile (aka the stock)' do
    game = Solitaire.new
    game.draw_pile.length.should == 24 # the remainder
  end

  it 'should have a waste (where cards from the stock go when they enter play)' do
    game = Solitaire.new
    game.draw_pile.length.should == 24 # the remainder
    game.waste.length.should     == 0

    game.draw_on_to_waste(3)

    game.draw_pile.length.should == 21
    game.waste.length.should     == 3

    # let's say one of the cards went into to play ...
    game.piles[0] << game.waste.draw
    game.waste.length.should == 2

    # if we do it again, it puts the old waste back in the draw pile and 
    # gives us 3 more
    game.waste! # shortcut
    game.draw_pile.length.should == 20 # 1 less card, which was played on a pile
    game.waste.length.should == 3
  end

  it 'should be able to move the top waste card to a pile (should yell if not allowed)' do
    pending 'cards need colors'
  end

end
