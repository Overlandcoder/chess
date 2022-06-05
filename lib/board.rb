require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def display
    add_background_color
    column_headings

    (0..7).each do |row|
      puts "  #{8 - row} #{@grid_clone[row].join} #{8 - row}  "
    end

    column_headings
    p grid[0].join
  end

  def column_headings
    puts '     ' + ('A'..'H').to_a.join('  ') + '     '
  end

  def add_background_color
    @grid_clone = grid.map(&:clone)
    @grid_clone.each_with_index do |row, idx|
      if idx.even?
        row.each_index do |idx|
          piece = row[idx]
          row[idx] = grey_bg + " #{piece ||= ' '} " + reset_code if idx.even?
          row[idx] = green_bg + " #{piece ||= ' '} " + reset_code if idx.odd?
        end
      else
        row.each_index do |idx|
          piece = row[idx]
          row[idx] = grey_bg + " #{piece ||= ' '} " + reset_code if idx.odd?
          row[idx] = green_bg + " #{piece ||= ' '} " + reset_code if idx.even?
        end
      end
    end
  end

  def grey_bg
    "\u001b[47m"
  end

  def green_bg
    "\u001b[42m"
  end

  def reset_code
    "\u001b[0m"
  end

  def add_pieces_to_grid(pieces)
    pieces.each do |piece|
      row = piece.position[0]
      column = piece.position[1]
      grid[row][column] = piece.symbol
    end
  end

  def square(row, column)
    grid[row][column]
  end

  def update_board
    
  end
end
