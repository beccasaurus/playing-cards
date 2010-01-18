require File.dirname(__FILE__) + '/spec_helper'

describe Solitaire do

  it 'new game should have 7 piles' do
    pending
    game = Solitaire.new

    game.piles.length.should == 7
    game.piles.first.length.should == 1
    game.piles.first.length.should == 2
    game.piles.first.length.should == 3
    game.piles.first.length.should == 4
    game.piles.first.length.should == 5
    game.piles.first.length.should == 6
    game.piles.first.length.should == 7
  end

  it 'should have a draw pile'

  it 'should have a flipped pile (better wording?  the ones you can actually use ...)'

end
