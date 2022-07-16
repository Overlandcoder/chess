require 'pry-byebug'
require_relative 'board'

class Rook
  attr_reader :color, :number, :position, :destination, :board, :possible_moves,
              :title, :moves_made

  attr_accessor :possible_moves

  POSSIBLE_MOVES = [[-1, 0], [0, 1], [1, 0], [0, -1]]

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
    @title = 'Rook'
    @moves_made = 0
  end

  def to_s
    color == :white ? "\u001b[37;1m\u265C" : "\u001b[30m\u265C"
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
    @possible_moves.include?([destination.row, destination.col])
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position(row = destination.row, col = destination.col)
    position.update_row(row)
    position.update_col(col)
    @moves_made += 1
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
                                          board.nil_or_opponent?(row, col, color)
                                          @possible_moves << [row, col]
        break unless board.square_at(row, col).nil?
      end
    end
  end
end
