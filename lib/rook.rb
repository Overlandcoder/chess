require 'pry-byebug'
require_relative 'board'

class Rook
  attr_reader :color, :number, :position, :destination, :board, :row, :column

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    @position = [[7, 0], [7, 7]][number] if color == 'white'
    @position = [[0, 0 ], [0, 7]][number] if color == 'black'
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
    board.within_board? && path_empty? && (vertical_move? || horizontal_move?)
  end

  def path_empty?
    if vertical_move?
      start_row = position[0]
      end_row = destination[0]
      column = position[1]

      (start_row - 1).downto(end_row).all? do |row|
        board.square_at(row, column).nil? ||
        board.square_at(end_row, column).color != board.square_at(start_row, column).color
      end
    # elsif horizontal_move?
     # start_column = position[1]
      # end_column = destination[1]
    end
  end

  def valid_path?(direction)
    @row = position[0]
    @column = position[1]
    square = board.square_at(row, column)

    until destination_reached(direction)
      direction == 'up' ? @row -= 1 : @row += 1
      direction == 'right' ? @column += 1 : @column -= 1

      return false if square

      if destination_reached(direction)
        return true if square.nil? || board.contains_opponent_piece?
      end
    end
  end

  def destination_reached(direction)
    if direction == 'up' || direction == 'down'
      row == destination[0]
    elsif direction == 'right' || direction == 'left'
      column == destination[1]
    end
  end

  def vertical_move?
    destination[0] != position[0] && destination[1] == position[1]
  end

  def horizontal_move?
    destination[0] == position[0] && destination[1] != position[1]
  end
end
