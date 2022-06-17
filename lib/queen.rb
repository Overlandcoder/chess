class Queen
  attr_reader :color, :number, :position, :destination, :board

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @moves = []
  end

  def create_coordinate
    case color
    when 'white'
      start_row, start_col = [7, 3]
      @position = Coordinate.new(row: start_row, col: start_col)
    when 'black'
      start_row, start_col = [0, 3]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265B"
    elsif color == 'black'
      "\u001b[30m\u265B"
    end
  end
end
