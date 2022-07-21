require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

class Piece
  attr_reader :color, :number, :position, :destination, :board, :moves_made,
              :moved_two_squares

  attr_accessor :possible_moves, :is_castling, :capturing_en_passant,
                :moved_last

  def self.for(type, color, number, board)
    case type
    when :rook
      Rook
    when :knight
      Knight
    when :bishop
      Bishop
    when :queen
      Queen
    when :king
      King
    when :pawn
      Pawn
    end.new(color, number, board)
  end
end
