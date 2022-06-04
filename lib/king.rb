class King
  attr_reader :color, :number, :position

  def initialize(color, number)
    @color = color
    @number = number
    @position = [7, 4] if color == 'white'
    @position = [0, 4] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265A"
    elsif color == 'black'
      "\u001b[30m\u265A"
    end
  end
end
