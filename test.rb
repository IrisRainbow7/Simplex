require 'minitest/autorun'
require './simplex'

class Simplextest < Minitest::Test
  def test_new_fraction
    assert Fraction.new(1,1)
  end
end

