class Fraction
  attr_accessor :numerator, :denominator

  def initialize(numerator, denominator)
    @numerator = numerator
    @denominator = denominator
  end

  def -@
    self.numerator = -self.numerator
    self
  end

  def +(other)
    case other
      when Fraction
        if self.denominator == other.denominator
          self.numerator += other.numerator
        else
          self.numerator, self.denominator, other = Fraction.complete(self, other)
          self.numerator += other.numerator
        end
        self.reduce
      when Integer
        self + other.to_fr 
      else
        nil
    end
  end

  def -(other)
    self + (-other)
  end

  def *(other)
    case other
      when Fraction
        self.numerator *= other.numerator
        self.denominator *= other.denominator
        self.reduce
      when Integer
        self * other.to_fr 
      else
        nil
    end
  end

  def /(other)
    self * other.to_fr.inverse
  end

  def ==(other)
    self.numerator == other.numerator and self.denominator == other.denominator
  end

  alias === ==

  def <=>(other)
    case other
      when Fraction
        if self > other
          1
        elsif self == other
          0
        elsif self < other
          -1
        else
          nil
        end
      when Integer
        self <=> other.to_fr
      else
        nil
      end
  end

  def >(other)
    self.numerator, self.denominator, other = Fraction.complete(self, other)
    self.numerator > other.numerator
  end

  def >=(other)
    self == other or self > other
  end

  def <(other)
    self.numerator, self.denominator, other = Fraction.complete(self, other)
    self.numerator < other.numerator
  end

  def <=(other)
    self == other or self < other
  end

  def **(other)
    case other
      when Fraction
        nil
      when Integer
        self.numerator **= other
       self.reduce 
      else
        nil
    end
  end


  def reduce
    gcd = self.numerator.gcd(self.denominator)
    self.numerator /= gcd
    self.denominator /= gcd
    self
  end

  def inverse
    self.numerator, self.denominator = self.denominator, self.numerator
    self
  end
  
  def to_fr
    self
  end

  def self.complete(a,b)
    if a.instance_of?(Fraction) and b.instance_of?(Fraction)
      lcm = a.denominator.lcm(b.denominator)
      a.numerator *= lcm/a.denominator
      b.numerator *= lcm/b.denominator
      a.denominator = lcm
      b.denominator = lcm
      return a.numerator, a.denominator, b
    elsif (a.instance_of?(Fraction) or a.instance_of?(Integer)) and (b.instance_of?(Fraction) or b.instance_of?(Integer))
      complete(a.to_fr, b.to_fr)
    end
  end
     

end  

class Integer
  def to_fr
    Fraction.new(self, 1)
  end
end

