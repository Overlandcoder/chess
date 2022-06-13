require 'pry-byebug'
require_relative 'board'

class Rook
  attr_reader :color, :number, :position, :destination, :board, :row, :column,
              :direction

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    set_position
    @row = position.row
    @column = position.col
  end

  def set_position
    case color
    when 'white'
      start_row = [[7, 0], [7, 7]][number][0]
      start_col = [[7, 0], [7, 7]][number][1]
      @position = Coordinate.new(row: start_row, col: start_col)
    when 'black'
      start_row = [[0, 0], [0, 7]][number][0]
      start_col = [[0, 0], [0, 7]][number][1]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def valid_move?
    (vertical_move? || horizontal_move?) && valid_path?
  end

  def valid_path?
    move_direction

    until destination_reached?
      next_square
      binding.pry
      return false if square && !destination_reached?
      return true if destination_reached? &&
                     (square.nil? || board.opponent_piece?(row, column, color))
    end
  end

  def destination_reached?
    if direction.include?('up') || direction.include?('down')
      row == destination.row
    elsif direction.include?('right') || direction.include?('left')
      column == destination.col
    end
  end

  def move_direction
    if destination.row < row
      @direction = 'up'
    elsif destination.row > row
      @direction = 'down'
    elsif destination.col < column
      @direction = 'left'
    elsif destination.col > column
      @direction = 'right'
    end
  end

  def square
    board.square_at(row, column)
  end

  def next_square
    case direction
    when 'up'
      @row -= 1
    when 'down'
      @row += 1
    when 'right'
      @column += 1
    when 'left'
      @column -= 1
    end
  end

  def vertical_move?
    destination.row != row && destination.col == column
  end

  def horizontal_move?
    destination.row == row && destination.col != column
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def symbol
    case color
    when 'white'
      "\u001b[37;1m\u265C"
    when 'black'
      "\u001b[30m\u265C"
    end
  end
end

def change_position(destination)
  # @destination = destination
  board.update_board(destination[0], destination[1], self) if valid_move?
end
