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
      row = row[0..-3] if row_number == 7
      row.each_with_index do |char, col_number|
        coordinate = Coordinate.new(row: row_number, col: col_number)
        piece = piece_from_fen_char(char, col_number)
        piece.update_position(row_number, col_number) if piece
        board.place(coordinate, piece)
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

  def piece_from_fen_char(char, col_number)
    case char
    when 'R'
      col_number = 1 if col_number > 0
      Piece.for(:rook, :white, col_number)
    when 'r'
      col_number = 1 if col_number > 0
      Piece.for(:rook, :black, col_number)
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
      Piece.for(:pawn, :white, col_number)
    when 'p'
      Piece.for(:pawn, :black, col_number)
    end
  end

  def current_player(fen_string)
    expanded_rows(fen_string).each_with_index do |row, row_number|
      next unless row_number == 7
      @current_player = :white if row.include?('w')
      @current_player = :black if row.include?('b')
    end
  end
end
