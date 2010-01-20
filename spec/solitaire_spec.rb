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

  it 'should be able to move the top waste card to a pile' do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    # cheat to make sure everything is setup properly
    game.waste.add The2ofClubs
    pile.add The3ofHearts
    game.waste.length.should == 1
    pile.length.should == 2

    game.move The2ofClubs, The3ofHearts

    game.waste.length.should == 0
    pile.length.should == 3
    pile[1].should == The3ofHearts
    pile[2].should == The2ofClubs
  end

  it '#move should accept short strings' do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    # cheat to make sure everything is setup properly
    game.waste.add The2ofClubs
    pile.add The3ofHearts
    game.waste.length.should == 1
    pile.length.should == 2

    game.move '2c', '3h'

    game.waste.length.should == 0
    pile.length.should == 3
    pile[1].should == The3ofHearts
    pile[2].should == The2ofClubs
  end

  it "should not be able to move a card onto a card that isn't sequentially +1 higher" do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    # cheat to make sure everything is setup properly
    game.waste.add The2ofClubs
    pile.add The4ofHearts
    game.waste.length.should == 1
    pile.length.should == 2

    lambda { game.move The2ofClubs, The4ofHearts }.should raise_error(/sequential/i)
  end

  it "should not be able to move a card onto a card of the same color" do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    # cheat to make sure everything is setup properly
    game.waste.add The2ofClubs
    pile.add The3ofSpades
    game.waste.length.should == 1
    pile.length.should == 2

    lambda { game.move The2ofClubs, The3ofSpades }.should raise_error(/same color/i)
  end

  it "should not be able to move a card that isn't on the top of the waste"

  it 'cards should have a visibility state' do
    game = Solitaire.new
    pile = game.piles.last

    pile.last.should     be_visible
    pile.last.should_not be_hidden

    pile.first.should_not be_visible
    pile.first.should     be_hidden
  end

  it 'when you move a card onto a pile, the last card of the pile AND the moved card should both be visible' do
    game = Solitaire.new
    pile = game.piles.last
    pile.length.should == 7

    # cheat to make sure everything is setup properly
    game.waste.add The2ofClubs
    pile.add The3ofHearts
    game.waste.length.should == 1
    pile.length.should == 8

    game.move The2ofClubs, The3ofHearts

    game.waste.length.should == 0
    pile.length.should == 9 # this blows up sometimes ... ??????
    pile[7].should == The3ofHearts
    pile[8].should == The2ofClubs

    pile[5].should_not be_visible # already wasn't
    pile[6].should     be_visible # already was
    pile[7].should     be_visible # [we added this illegally]
    pile[8].should     be_visible # #move should have marked this as visible

    game.inspect.should include('3H')
    game.inspect.should include('2C')
  end

  it 'can move Aces onto the suite piles' do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    # cheat to make sure everything is setup properly
    game.waste.add TheAceOfHearts

    game.suite_piles['heart'].length.should == 0

    game.move TheAceOfHearts

    game.suite_piles['heart'].length.should == 1
    game.suite_piles['heart'].first.should == TheAceOfHearts
    game.waste.length.should == 0
  end

  it 'can move sequentially higher cards onto the suite piles' do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    game.waste.add TheAceOfHearts
    game.move TheAceOfHearts
    game.suite_piles['heart'].length.should == 1
    game.inspect.should include('AH')

    game.waste.add The2ofHearts
    game.move The2ofHearts
    game.suite_piles['heart'].length.should == 2
    game.suite_piles['heart'].should include(TheAceOfHearts, The2ofHearts)
    game.inspect.should     include('2H')
    game.inspect.should_not include('AH')
  end

  it 'should require sequential cards to be moved onto suite piles' do
    game = Solitaire.new
    pile = game.piles.first
    pile.length.should == 1

    game.waste.add TheAceOfHearts
    game.move TheAceOfHearts
    game.suite_piles['heart'].length.should == 1

    game.waste.add The3ofHearts
    game.move The3ofHearts # for now, we're not raising an exception

    game.suite_piles['heart'].length.should == 1
    game.suite_piles['heart'].should     include(TheAceOfHearts)
    game.suite_piles['heart'].should_not include(The3ofHearts)
  end

  it 'can move a card from one pile to another'

  it 'flips over (shows) the last card on a pile after moving a card from one pile to another'

  it 'tells you that it cannot find a place to put a card if you try to move it'

  it 'calling move! will intelligently move a card (not just to the suite pile)'

  it '#move will let you manually move a card onto a suite pile or another pile'

  it 'you can move a card that is below other cards onto another pile (grab and move abunchof cards)'

  # TODO piles should have their own logic instead of being dumb?

end
