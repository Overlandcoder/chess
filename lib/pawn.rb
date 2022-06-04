class Pawn
  attr_reader :color, :number, :position

  def initialize(color, number)
    @color = color
    @number = number
    @position = [6, number] if color == 'white'
    @position = [1, number] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265F"
    elsif color == 'black'
      "\u001b[30m\u265F"
    end
  end
end
