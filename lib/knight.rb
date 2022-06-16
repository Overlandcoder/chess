require_relative 'board'

class Knight
  attr_reader :color, :number, :position

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
  end

  def create_coordinate
    case color
    when 'white'
      start_row, start_col = [[7, 1], [7, 6]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    when 'black'
      start_row, start_col = [[0, 1], [0, 6]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265E"
    elsif color == 'black'
      "\u001b[30m\u265E"
    end
  end
end
