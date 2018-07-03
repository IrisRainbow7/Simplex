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

if !ARGV.empty?
  File.open(ARGV[0], "r:utf-8" ) do |f|
    input << f.gets.split.map(&:to_i)
    loop do
      input_row = f.gets.chomp
      if input_row == 'end'
        break
      end
      input << input_row.split.map{|element| element.symbol? ? element : element.to_i}
    end
  end
else


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

end

input[0] += [0]*(input[1].size-input[0].size)

  pp Simplex.new(Simplex.makeTableFromQuestion(input,trace=true)).solve(trace=true).table.map{|row| row.map(&:to_s)}
