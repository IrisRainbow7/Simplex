require './lib/simplex'

class String
  def symbol?
    if self == '>' or self == '<' or self == '='
      return true
    end
    false
  end
end

input = []

#p "式の数と変数の数を入力してください(スペース区切り)"
#input << gets.split.map(&:to_i)
#input[0] += [0]*(input[0][1]+2-input[0].size)

p "最小化する式の係数を入力してください"
input << gets.split.map(&:to_i)

loop do
  p "制約条件の式を入力してください(end入力で終了)"
  input_row = gets.chomp
  if input_row == 'end'
    break
  end
  input << input_row.split.map{|element| element.symbol? ? element : element.to_i}
end

input[0] += [0]*(input[1].size-input[0].size)


  pp Simplex.new(Simplex.makeTableFromQuestion(input)).solve.table.map{|row| row.map(&:to_s)}
