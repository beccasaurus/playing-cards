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

  it 'should be able to #draw cards from the deck (removes them)' do
    deck = Deck.new
    deck.length.should == 52

    card = deck.draw
    card.should == The2ofSpades
    deck.length.should == 51

    card = deck.draw
    card.should == The3ofSpades
    deck.length.should == 50

    # many

    cards = deck.draw(2)
    cards.should == [The4ofSpades, The5ofSpades]
    deck.length.should == 48

    # if you pass a number, you will always get back an array, even if it's 1
    cards = deck.draw(1)
    cards.should == [The6ofSpades]
    deck.length.should == 47
  end

  it 'should be able to #add card(s) from the deck (adds them)' do
    deck = Deck.new
    deck.length.should == 52

    card = deck.draw
    card.should == The2ofSpades
    deck.length.should == 51

    deck.add card
    deck.last.should == The2ofSpades
    deck.length.should == 52

    # many

    cards = deck.draw(2)
    deck.length.should == 50
    cards.should == [The3ofSpades, The4ofSpades]

    deck.add *cards
    deck.length.should == 52
    deck.last.should == The4ofSpades

    cards = deck.draw(2)
    deck.length.should == 50
    cards.should == [The5ofSpades, The6ofSpades]

    # also takes an array
    deck.add cards
    deck.length.should == 52
    deck.last.should == The6ofSpades
  end

  it 'can #draw_from_top or #draw_from_bottom'

  it 'can #add_to_top or #add_to_bottom'

end
