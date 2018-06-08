require 'minitest/autorun'
require './lib/simplex'

class Simplextest < Minitest::Test

def test_simplex_without_artificial
  imput_data = [[0, 4, 3, 0, 0, 0],
                [2, 1, 2, 1, 0, 0],
                [19, 12, 18, 0, 1, 0],
                [7, 6, 4, 0, 0, 1]]

  s = Simplex.new(imput_data)
  s.solve

  expected_data = [[Fraction.new(-29,6), 0, 0, 0, Fraction.new(-1,30), Fraction.new(-11,15)],
                   [Fraction.new(1,6), 0, 0, 1, Fraction.new(-2,15), Fraction.new(-13,30)],
                   [Fraction.new(1,2), 0, 1, 0, Fraction.new(1,10), Fraction.new(1,5)],
                   [Fraction.new(5,6), 1, 0, 0, Fraction.new(-1,15), Fraction.new(-9,15)]]

  assert_equal expected_data, s.table
end

  def test_fraction
    assert Fraction.new(1,1)
  end



end
