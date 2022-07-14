class Player
  attr_reader :color
  attr_accessor :last_moved_pawn

  def initialize(color)
    @color = color
  end
end
