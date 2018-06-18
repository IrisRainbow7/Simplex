require 'minitest/autorun'
require './lib/simplex'

class Simplextest < Minitest::Test

  def setup
    @imput_data = [['基底', '値', 'x1', 'x2', 'y1', 'y2', 'y3'],
                   ['z', 0, 4, 3, 0, 0, 0],
                   ['y1', 2, 1, 2, 1, 0, 0],
                   ['y2', 19, 12, 18, 0, 1, 0],
                   ['y3',7, 6, 4, 0, 0, 1]]
    @expected_data = [['基底', '値', 'x1', 'x2', 'y1', 'y2', 'y3'],
                      ['z', Fraction.new(-29,6), 0, 0, 0, Fraction.new(-1,30), Fraction.new(-11,15)],
                      ['y1', Fraction.new(1,6), 0, 0, 1, Fraction.new(-2,15), Fraction.new(-13,30)],
                      ['x2', Fraction.new(1,2), 0, 1, 0, Fraction.new(1,10), Fraction.new(1,5)],
                      ['x1', Fraction.new(5,6), 1, 0, 0, Fraction.new(-1,15), Fraction.new(-9,15)]]
    @s = Simplex.new(@imput_data)
  end

  def test_simplex_without_artificial
    @s.solve
    assert_equal @expected_data, @s.table
  end

  def test_fraction
    assert Fraction.new(1,1)
  end

  def test_select_max_from_all
    n = @s.select_max_from_all
    assert_equal 2, n
  end

  def test_select_min_ratio_from_base
    @s.n = 2 
    m = @s.select_min_ratio_from_base
    assert_equal 4, m
  end

  def test_base_table
    expected_data = [['基底', '値', 'x1', 'x2', 'y1', 'y2', 'y3'],
                     ['z', 0, 0, 0, 0, 0, 0],
                     ['y1', 0, 0, 0, 0, 0, 0],
                     ['y2', 0, 0, 0, 0, 0, 0],
                     ['y3', 0, 0, 0, 0, 0, 0]]
    assert_equal expected_data, @s.base_table
  end

  def test_size
    assert_equal 2, @s.size_x
    assert_equal 3, @s.size_y
  end

  def test_swap
    @expected_data = [['基底', '値', 'x1', 'x2', 'y1', 'y2', 'y3'],
                     ['z', Fraction.new(-14,3), 0, Fraction.new(1,3), 0, 0, Fraction.new(-2,3)],
                     ['y1', Fraction.new(5,6), 0, Fraction.new(4,3), Fraction.new(1,1), 0, Fraction.new(-1,6)],
                     ['y2', Fraction.new(5,1), 0, Fraction.new(10,1), 0, Fraction.new(1,1), Fraction.new(-2,1)],
                     ['x1', Fraction.new(7,6), Fraction.new(1,1), Fraction.new(2,3), Fraction.new(0,0), Fraction.new(0,0), Fraction.new(1,6)]]
    @s.select_max_from_all
    @s.select_min_ratio_from_base
    @s.swap
    assert_equal @expected_data, @s.table
  end

  def test_phase2
    @expected_data = [["基底", "値", "x1", "x2", "y1", "y2", "y3"],
                      ["z", "-29/6", "0", "0", "0", "-1/30", "-3/5"],
                      ["y1", "1/6", "0", "0", "1", "-2/15", "1/10"],
                      ["x2", "1/2", "0", "1", "0", "1/10", "-1/5"],
                      ["x1", "5/6", "1", "0", "0", "-1/15", "3/10"]]
    @s.phase2
    assert_equal @expected_data, @s.table.map{|row| row.map(&:to_s)} 
  end
end
