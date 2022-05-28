require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, ' ') }
  end

  def display
    content = grid.clone
    content.each_with_index { |row, idx| row.unshift('  ', 8 - idx, ' ') }
    content.each_with_index { |row, idx| row.append(' ', 8 - idx, '  ') }

    puts '    ' + ('A'..'H').to_a.join(' ') + '     '
    (0..7).each { |i| puts content[i].join }
    puts '    ' + ('A'..'H').to_a.join(' ') + '     '
  end

  def background_color
    grid.each_with_index do |row, idx|
      if idx.even?
        row.each_with_index do |val, idx|
          if idx.even?
            row[idx] = "\u001b[47;1m  \u001b[0m"
          else
            row[idx] = "\u001b[42m  \u001b[0m"
          end
        end
      else
        row.each_with_index do |val, idx|
          if idx.odd?
            row[idx] = "\u001b[47;1m  \u001b[0m"
          else
            row[idx] = "\u001b[42m  \u001b[0m"
          end
        end
      end
    end
  end
end

board = Board.new
board.background_color
board.display
