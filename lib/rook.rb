class Rook
  attr_reader :position

  def initialize(number)
    @initial_positions = [[7, 0], [7, 7]]
    @position = @initial_positions[number]
  end

  def symbol
    "\u2656"
  end
end