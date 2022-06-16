require_relative 'board'

class Knight
  attr_reader :color, :number, :position, :destination

  POSSIBLE_MOVES = [[1, 2], [1, -2], [-1, 2], [-1, -2],
                    [2, 1], [2, -1], [-2, 1], [-2, -1]]

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

  def valid_move?
    POSSIBLE_MOVES.any? do |move|
      position.row + move[0] == destination.row &&
      position.col + move[1] == destination.col
    end
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
      "\u001b[37;1m\u265E"
    elsif color == 'black'
      "\u001b[30m\u265E"
    end
  end
end
