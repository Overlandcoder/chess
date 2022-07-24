class Piece
  attr_reader :color, :number, :position, :board, :moves_made,
              :moved_two_squares

  attr_accessor :possible_moves, :destination, :is_castling, :capturing_en_passant,
                :moved_last

  def self.for(piece_type, color, number)
    case piece_type
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
    end.new(color, number)
  end
end
