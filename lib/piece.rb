require_relative 'rook'

class Piece
  def self.for(type, i = 1)
    i = 7 if type == 'pawn'

    (0..i).each do |number|
      case type
      when 'rook'
        Rook
      end.new(number)
    end
  end
end