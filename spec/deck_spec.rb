require File.dirname(__FILE__) + '/spec_helper'

describe Deck do

  it 'should return a standard 52 card deck' do
    deck = Deck.new
    deck.length.should == 52
    deck.first.should  == The2ofSpades
    deck.last.should   == AceofDiamonds
  end

  it 'should be able to shuffle' do
    deck1 = Deck.new
    deck2 = Deck.new

    deck1.first.should == The2ofSpades
    deck2.first.should == The2ofSpades

    deck1.cards.map {|c| c.short_name }.should == deck2.cards.map {|c| c.short_name }
    deck2.shuffle!
    deck1.cards.map {|c| c.short_name }.should_not == deck2.cards.map {|c| c.short_name }

    deck2.length.should == 52
    deck2.first.should  be_a(Card)
  end

end
