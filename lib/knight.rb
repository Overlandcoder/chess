class Knight
  attr_reader :color, :number, :position

  def initialize(color, number)
    @color = color
    @number = number
    @position = [[7, 1], [7, 6]][number] if color == 'white'
    @position = [[0, 1 ], [0, 6]][number] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265E"
    elsif color == 'black'
      "\u001b[30m\u265E"
    end
  end
end