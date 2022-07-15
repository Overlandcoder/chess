require 'pry-byebug'

class Board
  attr_reader :white_pieces, :black_pieces

  TAN_BG = "\e[48;2;#{181};#{183};#{147}m".freeze
  GREEN_BG = "\e[48;2;#{84};#{140};#{42}m".freeze
  ORANGE_BG = "\e[48;2;#{255};#{181};#{87}m".freeze
  BRIGHT_GREEN_BG = "\e[48;2;#{193};#{255};#{134}m".freeze
  RESET_CODE = "\u001b[0m".freeze

  def initialize
    create_grid
    @white_pieces = []
    @black_pieces = []
  end

  def pieces(player_color)
    return @white_pieces if player_color == :white
    return @black_pieces if player_color == :black
  end

  def add_piece(piece)
    @white_pieces << piece if piece.color == :white
    @black_pieces << piece if piece.color == :black
  end

  def remove_piece(piece)
    @white_pieces.delete(piece) if piece.color == :white
    @black_pieces.delete(piece) if piece.color == :black
  end

  def display(highlighted = false)
    add_background_color unless highlighted
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
          row[idx] = TAN_BG + " #{piece ? piece.symbol : ' '} " + RESET_CODE if idx.even?
          row[idx] = GREEN_BG + " #{piece ? piece.symbol : ' '} " + RESET_CODE if idx.odd?
        end
      else
        row.each_index do |idx|
          piece = row[idx]
          row[idx] = TAN_BG + " #{piece ? piece.symbol : ' '} " + RESET_CODE if idx.odd?
          row[idx] = GREEN_BG + " #{piece ? piece.symbol : ' '} " + RESET_CODE if idx.even?
        end
      end
    end
  end

  def highlight_piece(row, col)
    piece = @grid[row][col]
    @grid_clone[row][col] = ORANGE_BG + " #{piece.symbol} " + RESET_CODE
  end

  def highlight_possible_moves(positions)
    positions.each do |position|
      row = position[0]
      col = position[1]
      piece = @grid[row][col]
      @grid_clone[row][col] = BRIGHT_GREEN_BG + " #{piece ? piece.symbol : ' '} " + RESET_CODE
    end
    display(true)
  end

  def attach_pieces(pieces)
    pieces.each do |piece|
      row = piece.position.row
      column = piece.position.col
      update(row, column, piece)
    end
  end

  def square_at(row, column)
    @grid[row][column]
  end

  def update(row, column, piece)
    @grid[row][column] = piece
  end

  def within_board?
    destination[0].between?(0, 7) && destination[1].between?(0, 7)
  end

  def nil_or_opponent?(row, col, current_piece_color)
    square_at(row, col).nil? ||
      square_at(row, col).color != current_piece_color
  end

  def opponent?(row, col, current_piece_color)
    square_at(row, col) && square_at(row, col).color != current_piece_color
  end

  private

  def create_grid
    @grid = Array.new(8) { Array.new(8) }
  end
end
