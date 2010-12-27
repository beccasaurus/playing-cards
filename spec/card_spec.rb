require File.dirname(__FILE__) + '/spec_helper'

describe Card do

  it 'should fail' do
    1.should == 2
  end

  it 'has a color (based on suite)' do
    TheJackOfSpades.color.should   == :black
    TheJackOfClubs.color.should    == :black
    TheJackOfHearts.color.should   == :red
    TheJackOfDiamonds.color.should == :red
  end

  it 'to_i gives the appropriate number for a card' do
    TheAceOfSpades.to_i.should    == 1
    The2ofClubs.to_i.should       == 2
    The10ofClubs.to_i.should      == 10
    TheJackOfDiamonds.to_i.should == 11
    TheQueenOfHearts.to_i.should  == 12
    TheKingOfClubs.to_i.should    == 13
  end

  it 'has a name, suite, and full_name (eg. "4 of Clubs")' do
    card = Card.new 4, :club
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can be initialized using a string like "4 of Clubs"' do
    card = Card.new '4 of Clubs'
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can be initialized using an abbreviated string like "4C"' do
    card = Card.new '4C'
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can be initialized using an abbreviated string like "JS"' do
    card = Card.new 'JS'
    card.name.should       == 'Jack'
    card.suite.should      == 'spade'
    card.full_name.should  == 'Jack of Spades'
    card.short_name.should == 'JS'
  end

  it 'can be initialized using a string like "The 4 of Clubs"' do
    card = Card.new 'The 4 of Clubs'
    card.name.should       == '4'
    card.suite.should      == 'club'
    card.full_name.should  == '4 of Clubs'
    card.short_name.should == '4C'
  end

  it 'can easily get a card via Card[4, :club]' do
    card = Card[4, :club]
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can easily get a card via Card[4, :clubs]' do
    card = Card[4, :clubs]
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can easily get a card via Card["4 of Clubs"]' do
    card = Card['4 of Clubs']
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can easily get a card via Card(4, :club)' do
    card = Card(4, :club)
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can easily get a card via Card(4, :clubs)' do
    card = Card(4, :clubs)
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'can easily get a card via Card("4 of Clubs")' do
    card = Card('4 of Clubs')
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'
  end

  it 'overrides const_missing so we can get a card by typing The4ofClubs' do
    card = The4ofClubs
    card.name.should      == '4'
    card.suite.should     == 'club'
    card.full_name.should == '4 of Clubs'

    TheJackofSpades.name.should      == 'Jack'
    TheJackofSpades.suite.should     == 'spade'
    TheJackofSpades.full_name.should == 'Jack of Spades'

    KingofSpades.name.should      == 'King'
    KingofSpades.suite.should     == 'spade'
    KingofSpades.full_name.should == 'King of Spades'

    AceofDiamonds.name.should      == 'Ace'
    AceofDiamonds.suite.should     == 'diamond'
    AceofDiamonds.full_name.should == 'Ace of Diamonds'
  end

end
