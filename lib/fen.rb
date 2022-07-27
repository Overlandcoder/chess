require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

class Fen
  attr_reader :board

  def to_board(fen_string)
    @board = Board.new
    expanded_rows(fen_string).each_with_index do |row, row_number|
      row.each_with_index do |char, col_number|
        coordinate = Coordinate.new(row: row_number, col: col_number)
        board.place(coordinate, piece_from_fen_char(char))
      end
    end
    board
  end

  def expanded_rows(fen_string)
    rows = fen_string.split('/')
    rows.map do |row|
      row.chars.reduce([]) do |arr, char|
        if char.to_i.zero?
          arr << char
        else
          arr + [nil] * char.to_i
        end
      end
    end
  end

  def piece_from_fen_char(char)
    case char
    when 'R'
      Piece.for(:rook, :white, 0)
    when 'r'
      Piece.for(:rook, :black, 0)
    when 'N'
      Piece.for(:knight, :white, 0)
    when 'n'
      Piece.for(:knight, :black, 0)
    when 'B'
      Piece.for(:bishop, :white, 0)
    when 'b'
      Piece.for(:bishop, :black, 0)
    when 'Q'
      Piece.for(:queen, :white, 0)
    when 'q'
      Piece.for(:queen, :black, 0)
    when 'K'
      Piece.for(:king, :white, 0)
    when 'k'
      Piece.for(:king, :black, 0)
    when 'P'
      Piece.for(:pawn, :white, 0)
    when 'p'
      Piece.for(:pawn, :black, 0)
    end
  end
end
