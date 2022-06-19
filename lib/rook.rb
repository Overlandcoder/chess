require 'pry-byebug'
require_relative 'board'

class Rook
  attr_reader :color, :number, :position, :destination, :board, :possible_moves

  POSSIBLE_MOVES = [[-1, 0], [0, 1], [1, 0], [0, -1]]

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
  end

  def create_coordinate
    case color
    when :white
      start_row, start_col = [[7, 0], [7, 7]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    when :black
      start_row, start_col = [[0, 0], [0, 7]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def valid_move?
    @possible_moves.any? do |move|
      move[0] == destination.row && move[1] == destination.col
    end
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position(row = destination.row, col = destination.col)
    position.update_row(row)
    position.update_col(col)
  end

  def generate_possible_moves
    @possible_moves.clear

    POSSIBLE_MOVES.each do |move|
      row = position.row
      col = position.col
      loop do
        row += move[0]
        col += move[1]
        break unless row.between?(0, 7) && col.between?(0, 7) &&
                                          board.nil_or_opponent?(row, col, self.color)
                                          @possible_moves << [row, col]
        break unless board.square_at(row, col).nil?
      end
    end
  end

  def symbol
    case color
    when :white
      "♜"
    when :black
      "\u001b[30m♜"
    end
  end
end
