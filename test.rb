require 'minitest/autorun'
require './simplex'

class Simplextest < Minitest::Test
  def test_new_fraction
    assert Fraction.new(1,1)
  end

  def test_add_fraction_same_denominator
    f1 = Fraction.new(1,3)
    f2 = Fraction.new(1,3)
    f = f1 + f2
    assert_equal 2, f.numerator
    assert_equal 3, f.denominator
  end
   
  def test_add_fraction_different_denominator
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    f = f1 + f2
    assert_equal 5, f.numerator
    assert_equal 6, f.denominator
  end

  def test_to_fr
    f = 3.to_fr
    assert_equal 3, f.numerator
    assert_equal 1, f.denominator
  end

  def test_add_fraction_different_denominator
    f1 = Fraction.new(1,2)
    i = 1 
    f = f1 + i
    assert_equal 3, f.numerator
    assert_equal 2, f.denominator
  end

  def test_inverse_sign
    f1 = Fraction.new(1,2)
    f2 = -f1
    assert_equal -1, f2.numerator
    assert_equal 2, f2.denominator
  end

  def test_subtract_fraction
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    f = f1 - f2
    assert_equal 1, f.numerator
    assert_equal 6, f.denominator
  end

  def test_subtract_fraction_and_integer
    f1 = Fraction.new(1,2)
    i = 1
    f = f1 - i
    assert_equal -1, f.numerator
    assert_equal 2, f.denominator
  end

  def test_multiplication_fraction
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    f = f1 * f2
    assert_equal 1, f.numerator
    assert_equal 6, f.denominator
  end

  def test_multiplication_fraction_with_reduce
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(2,3)
    f = f1 * f2
    assert_equal 1, f.numerator
    assert_equal 3, f.denominator
  end

  def test_multiplication_fraction_with_integer
    f1 = Fraction.new(1,2)
    i = 3
    f = f1 * i
    assert_equal 3, f.numerator
    assert_equal 2, f.denominator
  end

  def test_inverse
    f = Fraction.new(2,3)
    f.inverse
    assert_equal 3, f.numerator
    assert_equal 2, f.denominator
  end

  def test_divide
    f1 = Fraction.new(1,4)
    f2 = Fraction.new(2,3)
    f = f1 / f2
    assert_equal 3, f.numerator
    assert_equal 8, f.denominator
  end
   
  def test_compare_same
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,2)
    assert f1 == f2
  end

  def test_compare_diffrent
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,4)
    refute f1 == f2
  end

  def test_complete
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    f1.numerator, f1.denominator, f2 = Fraction.complete(f1, f2)
    assert_equal 3, f1.numerator
    assert_equal 6, f1.denominator
    assert_equal 2, f2.numerator
    assert_equal 6, f2.denominator
  end

  def test_compare_true
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    assert f1 > f2
    assert f2 < f1
  end

  def test_compare_false
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    refute f1 < f2
    refute f2 > f1
  end

  def test_compare_equal
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    refute f1 <= f2
    refute f2 >= f1
    assert f1 <= f1
    assert f2 >= f2
  end

  def test_ufo
    f1 = Fraction.new(1,2)
    f2 = Fraction.new(1,3)
    refute (f1 <=> f2).negative?
    assert (f2 <=> f1).negative?
    assert (f1 <=> f1).zero?
    assert (f1 <=> 1).negative?
  end

  def test_power
    f1 = Fraction.new(2,3)
    f1 **= 3
    assert_equal 8, f1.numerator
    assert_equal 3, f1.denominator
  end

  def test_to_s
    f = Fraction.new(1,2)
    assert_equal '1/2', f.to_s
  end

end

