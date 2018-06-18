require './lib/fraction'


class Simplex
  attr_accessor :table, :n, :m, :size_x, :size_y

  def initialize(table)
    @table = table
    @table_size_y = table.size
    @table_size_x = table[0].size
    @size_y = @table_size_y - 2
    @size_x = @table_size_x - @size_y - 2
    @n = 0
    @m = 0
  end

  def solve()

  end

  def phase1()

  end

  def phase2
    until self.table[1][2..-1].map(&:to_fr).all?{|element| element.zero? or element.negative?}
      self.select_max_from_all
      self.select_min_ratio_from_base
      self.swap
      #pp self.table.map{|row| row.map(&:to_s)}
    end
  end

  def select_max_from_all
    self.n = self.table[1][2..-1].index(self.table[1][2..-1].map(&:to_fr).max)+2
  end

  def select_min_ratio_from_base
    self.m = []
    2.upto(self.table.size-1) do |i|
      if self.table[i][self.n] > 0
        self.m << self.table[i][1].to_f/self.table[i][self.n].to_f
      else
        self.m << Float::INFINITY
      end
    end
    self.m = self.m.index(self.m.min)+2
  end

  def base_table
    tmp_table = Array.new(@table_size_y).map{ Array.new(@table_size_x,0) }
    tmp_table[0] = self.table[0]
    tmp_table[1][0] = 'z'
    2.upto(@table_size_y-1) do |i|
      tmp_table[i][0] = self.table[i][0]
    end
    tmp_table
  end

  def swap
    tmp_table = self.base_table
    replacement = self.table[0].index(self.table[self.m][0])
    one_positon = -1
    2.upto(@table_size_y-1) do |i|
      tmp_table[i][self.n] = self.table[i][replacement]
      if self.table[i][replacement] == 1
        one_positon = i
      end
    end
    if one_positon == -1
      raise 'something is broken'
    end
    ratio = self.table[one_positon][self.n]
    1.upto(@table_size_x-1) do |j|
      if ratio.instance_of?(Integer)
        tmp_table[one_positon][j] =  Fraction.new(self.table[one_positon][j],ratio) 
      else
        tmp_table[one_positon][j] =  ratio.inverse * self.table[one_positon][j]
      end
    end
    1.upto(@table_size_y-1) do |i|
      next if i == one_positon
      1.upto(@table_size_x-1) do |j|
        tmp_table[i][j] = self.table[i][j].to_fr - tmp_table[one_positon][j].to_fr * self.table[i][self.n].to_fr
      end
    end
    tmp_table[self.m][0] = self.table[0][self.n]
    self.table = tmp_table
  end


end

if __FILE__ == $0
  input_data = [['基底', '値', 'x1', 'x2', 'y1', 'y2', 'y3'],
                ['z', 0, 4, 3, 0, 0, 0],
                ['y1', 2, 1, 2, 1, 0, 0],
                ['y2', 19, 12, 18, 0, 1, 0],
                ['y3',7, 6, 4, 0, 0, 1]]
  s = Simplex.new(input_data.map {|row| row.map{|element| element.instance_of?(Integer) ? element.to_fr : element }})
  s.phase2
  pp s.table.map{|row| row.map(&:to_s)}
end
