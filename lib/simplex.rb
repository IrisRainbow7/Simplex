require './lib/fraction'

class String
  def integer?
    false
  end
end

class Simplex
  attr_accessor :table, :n, :m, :size_x, :size_y, :trace

  def initialize(table)
    @table = table
    @table_size_y = table.size
    @table_size_x = table[0].size
    @size_y = @table_size_y - 2
    @size_x = @table_size_x - @size_y - 2
    @n = 0
    @m = 0
    @trace = false
  end

  def self.makeTableFromQuestion(questionTable, trace=false)
    symbol_index = questionTable[1].index(questionTable[1].find{|element| !element.integer? })
    table = [['基底', '値']]
    1.upto(questionTable.size + questionTable[0].size - 3) do |i|
      if i > questionTable[0].size-2 and questionTable[i-questionTable[0].size-2][symbol_index] == '='
        next
      end
      table[0] << "x#{i}"
    end
    y_index = 1
    ys = []
    questionTable[1..-1].each do |row|
      if row[symbol_index] == '>' or row[symbol_index] == '='
        table[0] << "y#{y_index}"
        ys << y_index
        y_index += 1
      end
    end
    if y_index == 1
      y_index = questionTable.size
    end
    table << ['z', 0] + questionTable[0].map{|i| -i}
    table[1] += [0]*(table[0].size-table[1].size)
    yss = ys.clone
    2.upto(questionTable.size) do |i|
      table << ["x#{questionTable.size-2+i-1}"] + [questionTable[i-1][-1]] + questionTable[i-1][0..symbol_index-1]
      if questionTable[i-1][symbol_index] == '>' or questionTable[i-1][symbol_index] == '='
        table[-1][0] = "y#{yss.shift}"
      end
      1.upto(2) do |j|
        if ys.empty? and j == 2
          break
        end
        tmp_table = [0]*(y_index-1)
        if questionTable[i-1][symbol_index] == '<' or j == 2
          tmp_table[i-2] = 1
        elsif questionTable[i-1][symbol_index] == '>'
          tmp_table[i-2] = -1
        end
        table[i] += tmp_table
      end
    end
    if trace
      pp table
    end
    table
  end

  def solve(trace=false)
    if trace
      self.trace = true
    end
    if self.needPhase1?
      self.phase1
      self.phase2
    else
      self.phase2(mode="phase2only")
    end
    self
  end

  def needPhase1?
    tf = false
    2.upto(self.table.size-1) do |i|
      if self.table[i][0][0] == 'y'
        tf = true
      end
    end
    tf
  end

  def minimize
    until self.table[1][2..-1].map(&:to_fr).all?{|element| element.zero? or element.negative?}
      self.select_max_from_all
      self.select_min_ratio_from_base
      self.swap
      if self.trace
        pp self.table.map{|row| row.map(&:to_s)}
      end
    end
  end

  def phase1
    p "phase1"
    @table_size_y += 1
    self.table << self.table[1].clone
    self.table[1][0] = 'w'
    1.upto(self.table[0].size-1) do |i|
      self.table[1][i] = 0
      2.upto(self.table.size-2) do |j|
        if self.table[j][0][0] == 'y'
          self.table[1][i] += self.table[j][i]
        end
      end
      if self.table[0][i][0] == 'y'
        self.table[1][i] += -1
      end
    end
    minimize
  end

  def phase2(mode="")
    p "phase2"
    if mode == ""
      self.table[1] = self.table[-1]
      @table_size_y -= 1
      @table_size_x -= 3
      self.table.delete_at(-1)
      self.table.each.with_index do |row, i|
        self.table[i] = row[0..-4]
      end
    end
    minimize
  end

  def select_max_from_all
    self.n = self.table[1][2..-1].index(self.table[1][2..-1].map(&:to_fr).max)+2
  end

  def select_min_ratio_from_base
    self.m = []
    2.upto(self.table.size-1) do |i|
      if self.table[i][0] == 'w' or self.table[i][0] == 'z'
        self.m << Float::INFINITY
      elsif self.table[i][self.n] > 0
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
    tmp_table[1][0] = self.table[1][0]
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
  input_data2 = [['基底', '値', 'x1', 'x2', 'y1', 'y2', 'y3'],
                 ['z', 0, 1, 1, 0, 0, 0],
                 ['y1', 3, 1, 2, 1, 0, 0],
                 ['y2', 2, 1, 0, 0, 1, 0],
                 ['y3',1, 0, 1, 0, 0, 1]]
  input_data3 = [['基底', '値', 'x1', 'x2', 'y1', 'y2'],
                 ['z', 0, 2, 1, 0, 0],
                 ['y1', 18, 1, 3, 1, 0],
                 ['y2', 25, 5, 2, 0, 1]]
  input_data4 = [['基底', '値', 'x1', 'x2', 'x3', 'x4', 'x5'],
                 ['z', Fraction.new(219,5), 0, Fraction.new(2,5), 0, 0, Fraction.new(-3,5)],
                 ['x1', Fraction.new(73,5), 1, Fraction.new(4,5), 0, 0, Fraction.new(-1,5)],
                 ['x3', Fraction.new(46,5), 0, Fraction.new(3,5), 1, 0, Fraction.new(-2,5)],
                 ['x4',Fraction.new(12,5), 0, Fraction.new(1,5), 0, 1, Fraction.new(-4,5)]]
  input_data5 = [['基底', '値', 'x1', 'x2','x3', 'x4', 'y2', 'y3'],
                 ['w', 20, 4, 4, 0, -1, 0, 0],
                 ['x3', 20, 2, 5, 1, 0, 0, 0],
                 ['y2', 14, 3, 2, 0, -1, 1, 0],
                 ['y3', 6, 1, 2, 0, 0, 0, 1],
                 ['z', 0, 2, 3, 0, 0, 0, 0]]
#  s = Simplex.new(input_data5.map {|row| row.map{|element| element.instance_of?(Integer) ? element.to_fr : element }})
#  s.phase2
#  pp s.table.map{|row| row.map(&:to_s)}
  questionTable1 = [[3,2,0,0],
                    [2,1,'>',20],
                    [4,3,'>',56],
                    [5,4,'>',73]]
  t = Simplex.makeTableFromQuestion(questionTable1)
#  pp t
  tt = Simplex.new(t)
  tt.solve
  pp tt.table.map{|row| row.map(&:to_s)}
end
