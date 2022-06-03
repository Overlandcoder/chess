require_relative 'rook'

class Piece
  def self.for(type, color, number)
    case type
    when 'rook'
      Rook
    end.new(color, number)
  end
end