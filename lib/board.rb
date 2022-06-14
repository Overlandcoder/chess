require 'pry-byebug'

class Board
  def initialize
    create_grid
  end

  def display
    add_background_color
    column_headings

    (0..7).each do |row|
      puts "  #{8 - row} #{@grid_clone[row].join} #{8 - row}  "
    end

    column_headings
  end

  def column_headings
    puts "     #{('A'..'H').to_a.join('  ')}     "
  end

  def add_background_color
    @grid_clone = @grid.map(&:clone)
    @grid_clone.each_with_index do |row, idx|
      if idx.even?
        row.each_index do |idx|
          piece = row[idx]
          row[idx] = grey_bg + " #{piece ? piece.symbol : ' '} " + reset_code if idx.even?
          row[idx] = green_bg + " #{piece ? piece.symbol : ' '} " + reset_code if idx.odd?
        end
      else
        row.each_index do |idx|
          piece = row[idx]
          row[idx] = grey_bg + " #{piece ? piece.symbol : ' '} " + reset_code if idx.odd?
          row[idx] = green_bg + " #{piece ? piece.symbol : ' '} " + reset_code if idx.even?
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

  def attach_piece(pieces)
    pieces.each do |piece|
      row = piece.position.row
      column = piece.position.col
      update_board(row, column, piece)
    end
  end

  def square_at(row, column)
    @grid[row][column]
  end

  def update_board(row, column, piece)
    @grid[row][column] = piece
  end

  def within_board?
    destination[0].between?(0, 7) && destination[1].between?(0, 7)
  end

  def opponent_piece?(row, column, current_piece_color)
    square_at(row, column).color != current_piece_color
  end

  private

  def create_grid
    @grid = Array.new(8) { Array.new(8) }
  end
end
