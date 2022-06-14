class Player
  attr_reader :color, :pieces

  def initialize(color)
    @color = color
    @pieces = []
  end

  def add_piece(piece)
    @pieces << piece
  end

  def remove_piece(piece)
    @pieces.delete(piece)
  end
end
