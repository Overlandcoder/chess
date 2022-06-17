require_relative 'board'

class Knight
  attr_reader :color, :number, :position, :destination, :moves

  POSSIBLE_MOVES = [[1, 2], [1, -2], [-1, 2], [-1, -2],
                    [2, 1], [2, -1], [-2, 1], [-2, -1]]

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @moves = []
    generate_possible_moves
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

  def valid_move?(row = destination.row, col = destination.col)
    POSSIBLE_MOVES.any? do |move|
      position.row + move[0] == row &&
      position.col + move[1] == col
    end
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position
    position.update_row(destination.row)
    position.update_col(destination.col)
  end

  def generate_possible_moves
    (0..7).each do |row|
      (0..7).each do |col|
        @moves << [row, col] if valid_move?(row, col)
      end
    end
  end

  def symbol
    if color == 'white'
      "\u265E"
    elsif color == 'black'
      "\u001b[30m\u265E"
    end
  end
end
