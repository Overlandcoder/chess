require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

class Piece
  def self.for(type, color, number, board)
    case type
    when 'rook'
      Rook
    #when 'knight'
     # Knight
    #when 'bishop'
     # Bishop
    #when 'queen'
     # Queen
    #when 'king'
     # King
    end.new(color, number, board)
  end
end
