class Queen
  attr_reader :color, :number, :position

  def initialize(color, number)
    @color = color
    @number = number
    @position = [7, 3] if color == 'white'
    @position = [0, 3] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265B"
    elsif color == 'black'
      "\u001b[30m\u265B"
    end
  end
end
