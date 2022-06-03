class Rook
  attr_reader :color, :number, :position

  def initialize(color, number)
    @color = color
    @number = number
    @position = [[7, 0], [7, 7]][number] if color == 'white'
    @position = [[0, 0 ], [0, 7]][number] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u265C"
    elsif color == 'black'
      "\u001b[30m\u265C"
    end
  end
end