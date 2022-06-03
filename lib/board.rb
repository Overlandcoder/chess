require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, ' ') }
  end

  def display
    add_background_color
    content = grid.clone
    content.each_with_index { |row, idx| row.unshift('  ', 8 - idx, ' ') }
    content.each_with_index { |row, idx| row.append(' ', 8 - idx, '  ') }

    puts '     ' + ('A'..'H').to_a.join('  ') + '     '
    (0..7).each { |i| puts content[i].join }
    puts '     ' + ('A'..'H').to_a.join('  ') + '     '
  end

  def add_background_color
    grid_clone = grid.clone
    grid_clone.each_with_index do |row, idx|
      if idx.even?
        row.each_with_index do |val, idx|
          if idx.even?
            piece = row[idx]
            row[idx] = "\u001b[47m #{piece} \u001b[0m"
          else
            piece = row[idx]
            row[idx] = "\u001b[42m #{piece} \u001b[0m"
          end
        end
      else
        row.each_with_index do |val, idx|
          if idx.odd?
            piece = row[idx]
            row[idx] = "\u001b[47m #{piece} \u001b[0m"
          else
            piece = row[idx]
            row[idx] = "\u001b[42m #{piece} \u001b[0m"
          end
        end
      end
    end
  end

  def add_pieces_to_display(pieces)
    pieces.each do |piece|
      row = piece.position[0]
      column = piece.position[1]
      grid[row][column] = piece.symbol
    end
  end
end