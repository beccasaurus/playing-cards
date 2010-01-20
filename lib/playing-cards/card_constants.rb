class Card #:nodoc:

  # ...
  module Constants
    def const_missing constant_name
      if constant_name.to_s =~ /(The)?(.+)of[spade|club|diamond|heart](s)?/i
        Card.new constant_name.to_s
      else
        super
      end
    end
  end

end

Object.send :extend, Card::Constants
