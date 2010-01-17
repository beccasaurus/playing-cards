# Misc playing card stuff

class Card

  attr_accessor :name, :suite

  def initialize name, suite = nil
    if suite.nil?
      parse(name)
    else
      self.name, self.suite = name, suite
    end
  end

  def name= value
    @name = value.to_s.strip.sub(/^The\s*/i, '')
  end

  def suite= value
    @suite = value.to_s.strip.downcase.sub(/s$/i, '')
  end

  def full_name
    "#{ name } of #{ suite.capitalize }s"
  end

  def self.[] name, suite = nil
    Card.new name, suite
  end

private

  def parse name_to_parse
    name, suite = name_to_parse.split('of')
    self.name, self.suite = name, suite
  end

end

def Object.const_missing constant_name
  if constant_name.to_s =~ /(The)?(.+)of[spade|club|diamond|heart](s)?/i
    Card.new constant_name.to_s
  else
    super
  end
end

def Card name, suite = nil
  Card[name, suite]
end
