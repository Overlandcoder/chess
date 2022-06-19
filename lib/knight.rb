require_relative 'board'

class Knight
  attr_reader :color, :number, :position, :destination, :possible_moves, :board

  POSSIBLE_MOVES = [[1, 2], [1, -2], [-1, 2], [-1, -2],
                    [2, 1], [2, -1], [-2, 1], [-2, -1]]

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
      start_row, start_col = [[7, 1], [7, 6]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    when :black
      start_row, start_col = [[0, 1], [0, 6]][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def valid_move?(row = destination.row, col = destination.col)
    POSSIBLE_MOVES.any? do |move|
      position.row + move[0] == row &&
      position.col + move[1] == col
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

    (0..7).each do |row|
      (0..7).each do |col|
        @possible_moves << [row, col] if valid_move?(row, col) &&
                                board.nil_or_opponent?(row, col, self.color)
      end
    end
  end

  def symbol
    if color == :white
      "♞"
    elsif color == :black
      "\u001b[30m♞"
    end
  end
end
