require 'pry-byebug'
require_relative 'board'

class Rook
  attr_reader :color, :position, :destination, :board, :row, :column

  def initialize(color, number, board)
    @color = color
    @board = board
    @position = [[7, 0], [7, 7]][number] if color == 'white'
    @position = [[0, 0], [0, 7]][number] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265C"
    elsif color == 'black'
      "\u001b[30m\u265C"
    end
  end

  def change_position(destination)
    @destination = destination

    if valid_move?
    end
  end

  def valid_move?
    board.within_board? && valid_path?
  end

  def valid_path?(direction)
    @row = position[0]
    @column = position[1]
    square = board.square_at(row, column)
    binding.pry


    until destination_reached(direction)
      next_square(direction)

      return false if square

      if destination_reached(direction)
        return true if square.nil? || board.contains_opponent_piece?
      end
    end
  end

  def destination_reached(direction)
    if direction.include?('up') || direction.include?('down')
      row == destination[0]
    elsif direction.include?('right') || direction.include?('left')
      column == destination[1]
    end
  end

  def next_square(direction)
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
    destination[0] != position[0] && destination[1] == position[1]
  end

  def horizontal_move?
    destination[0] == position[0] && destination[1] != position[1]
  end
end
