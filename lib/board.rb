require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, ' ') }
  end

  def display
    content = grid.clone
    content.each_with_index { |row, idx| row.unshift('  ', 8 - idx) }
    content.each_with_index { |row, idx| row.append(8 - idx, '  ') }

    puts '     ' + ('A'..'H').to_a.join(' ') + '     '
    (0..7).each { |i| puts content[i].join(' ') }
    puts '     ' + ('A'..'H').to_a.join(' ') + '     '
  end
end

Board.new.display
