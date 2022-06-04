class Player
  attr_reader :name, :color, :pieces

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
  end

  def add_piece(piece)
    @pieces << piece
  end
end