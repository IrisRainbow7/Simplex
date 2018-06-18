class Fraction
  attr_accessor :numerator, :denominator

  def initialize(numerator, denominator)
    if numerator == 0
      denominator = 0
    elsif denominator == 0
      raise ZeroDivisionError
      nil
    end
    @numerator = numerator
    @denominator = denominator
    self.reduce!
  end

  def -@
    answer = Fraction.new(-self.numerator, self.denominator)
  end

  def +(other)
    answer = Fraction.new(self.numerator, self.denominator)
    if self.zero?
      return other
    elsif other.zero?
      return answer
    end
    case other
      when Fraction
        if answer.denominator == other.denominator
          answer.numerator += other.numerator
        else
          answer, other = answer.complete(other)
          answer.numerator += other.numerator
        end
        answer.reduce
      when Integer
        answer + other.to_fr
      else
        nil
    end
  end

  def -(other)
    self + (-other)
  end

  def *(other)
    answer = Fraction.new(self.numerator, self.denominator)
    case other
      when Fraction
        answer.numerator *= other.numerator
        answer.denominator *= other.denominator
        answer.reduce
      when Integer
        if other == 0
          return 0
        end
        answer * other.to_fr
      else
        nil
    end
  end

  def /(other)
    if other == 0
      raise ZeroDivisionError
      nil
    end
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
        if other==0
          return self.numerator
        end
        self <=> other.to_fr
      else
        nil
      end
  end

  def >(other)
    answer = Fraction.new(self.numerator, self.denominator)
    if self.zero?
      return (other.negative? ? true : false)
    end
    if other.zero?
      return (self.negative? ? false : true)
    end
    answer, other = answer.complete(other)
    answer.numerator > other.numerator
  end

  def >=(other)
    self == other or self > other
  end

  def <(other)
    answer = Fraction.new(self.numerator, self.denominator)
    if self.zero?
      return (other.negative? ? false : true)
    end
    if other.zero?
      return (self.negative? ? true : false)
    end
  answer, other = answer.complete(other)
    answer.numerator < other.numerator
  end

  def <=(other)
    self == other or self < other
  end

  def **(other)
    answer = Fraction.new(self.numerator, self.denominator)
    case other
      when Fraction
        raise 'Fraction::** suport only Integer'
        nil
      when Integer
        answer.numerator **= other
        answer.denominator **= other
        answer.reduce
      else
        nil
    end
  end


  def reduce
    answer = Fraction.new(self.numerator, self.denominator)
    if answer.numerator == 0 and answer.denominator == 0
      return 0
    end
    gcd = answer.numerator.gcd(answer.denominator)
    answer.numerator /= gcd
    answer.denominator /= gcd
    answer
  end

 def reduce!
    if self.numerator == 0 and self.denominator == 0
      return 0
    end
    gcd = self.numerator.gcd(self.denominator)
    self.numerator /= gcd
    self.denominator /= gcd
    self
 end

  def inverse
    answer = Fraction.new(self.denominator, self.numerator)
    answer.reduce
  end

  def inverse!
    self.numerator, self.denominator = self.denominator, self.numerator
    self
  end

  def to_fr
    self
  end

  def complete(other)
    case other
      when Fraction
        answer1 = Fraction.new(self.numerator, self.denominator)
        answer2 = Fraction.new(other.numerator, other.denominator)
        lcm = answer1.denominator.lcm(answer2.denominator)
        answer1.numerator *= lcm/answer1.denominator
        answer2.numerator *= lcm/answer2.denominator
        answer1.denominator = lcm
        answer2.denominator = lcm
        return answer1, answer2
     when Integer
        self.complete(other.to_fr)
      else
        nil
    end
  end

  def to_s
    "#{self.numerator}/#{self.denominator}"
  end

  def to_i
    if self.zero?
      return 0
    end
    (self.numerator / self.denominator).to_i
  end

  def to_f
    if self.zero?
      return 0
    end
    (self.numerator.to_f / self.denominator.to_f).to_f
  end

  def zero?
    (self.numerator == 0 and self.denominator == 0)
  end

  def negative?
    self.numerator < 0
  end


end


class Integer
  def to_fr
    Fraction.new(self, 1)
  end
end

