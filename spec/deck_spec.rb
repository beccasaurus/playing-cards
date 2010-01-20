require File.dirname(__FILE__) + '/spec_helper'

describe Deck do

  it 'should return a standard 52 card deck' do
    deck = Deck.standard
    deck.length.should == 52
    deck.first.should  == The2ofSpades
    deck.last.should   == AceofDiamonds
  end

  it 'should be able to shuffle' do
    deck1 = Deck.standard
    deck2 = Deck.standard

    deck1.first.should == The2ofSpades
    deck2.first.should == The2ofSpades

    deck1.cards.map {|c| c.short_name }.should == deck2.cards.map {|c| c.short_name }
    deck2.shuffle!
    deck1.cards.map {|c| c.short_name }.should_not == deck2.cards.map {|c| c.short_name }

    deck2.length.should == 52
    deck2.first.should  be_a(Card)
  end

  it 'should be able to #draw cards from the deck (removes them)' do
    deck = Deck.standard
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
    deck = Deck.standard
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

  it 'can #draw_all' do
    deck1 = Deck.standard
    deck2 = Deck.standard

    deck1.length.should == 52
    deck2.length.should == 52

    deck2.add deck1.draw_all

    deck1.length.should == 0
    deck2.length.should == 104

    # and we can add some back ...
    deck1.add deck2.draw(5)

    deck1.length.should == 5
    deck2.length.should == 99
  end

  it 'can #draw_from_top or #draw_from_bottom'

  it 'can #add_to_top or #add_to_bottom'

  it 'can see if a deck includes a card' do
    deck = Deck.standard
    deck.should include(The2ofSpades)

    deck.first.should == The2ofSpades
    deck.draw # takes the first one, which is the 2 of spades

    deck.should_not include(The2ofSpades)
  end

  it 'should be able to remove a specific card' do
    deck = Deck.standard
    deck.should include(The5ofSpades)

    deck.length.should == 52
    the_5 = deck.delete The5ofSpades
    the_5.full_name.should == '5 of Spades'
    deck.length.should == 51

    deck.should_not include(The5ofSpades)

    # ALIAS remove
    deck.remove(The6ofSpades).full_name.should == '6 of Spades'
    deck.length.should == 50

    # can also draw
    deck.draw(The7ofSpades).full_name.should == '7 of Spades'
    deck.length.should == 49
  end
  
  it 'should be able to instantiate a deck with an array of cards' do
    Deck.new.length.should == 0
    Deck.new([TheJackofSpades]).length.should == 1
    Deck.new([TheJackofSpades, The2ofHearts]).length.should == 2
  end

  it '#draw should actually return a deck' do
    deck = Deck.standard
    deck.draw.should be_a(Card)
    deck.draw(1).should be_a(Deck)
    deck.draw(2).should be_a(Deck)
  end

end
