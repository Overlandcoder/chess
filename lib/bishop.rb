class Bishop
  attr_reader :color, :number, :position

  def initialize(color, number)
    @color = color
    @number = number
    @position = [[7, 2], [7, 5]][number] if color == 'white'
    @position = [[0, 2 ], [0, 5]][number] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265D"
    elsif color == 'black'
      "\u001b[30m\u265D"
    end
  end
end
