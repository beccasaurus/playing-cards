require File.dirname(__FILE__) + '/spec_helper'

describe Deck do

  it 'should return a standard 52 card deck' do
    deck = Deck.new
    deck.length.should == 52
    deck.first.should  == The2ofSpades
    deck.last.should   == AceofDiamonds
  end

  it 'should be able to shuffle'

end
