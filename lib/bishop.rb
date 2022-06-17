class Bishop
  attr_reader :color, :number, :position, :destination

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
  end

  def create_coordinate
    case color
    when 'white'
      start_row, start_col = [[7, 2], [7, 5]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    when 'black'
      start_row, start_col = [[0, 2], [0, 5]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def valid_move?
    (position.row - position.col).abs == (destination.row - destination.col).abs ||
    (position.row + position.col) == (destination.row + destination.col)
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position
    position.update_row(destination.row)
    position.update_col(destination.col)
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265D"
    elsif color == 'black'
      "\u001b[30m\u265D"
    end
  end
end
