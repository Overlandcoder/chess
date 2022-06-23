class Pawn
  attr_reader :color, :number, :position, :destination, :board

  POSSIBLE_MOVES = [[-1, 0], [1, 0], [-2, 0], [2, 0]]

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
    @title = 'Pawn'
    @moves_made = 0
  end

  def create_coordinate
    case color
    when :white
      start_row = 6
      start_col = [0, 1, 2, 3, 4, 5, 6, 7][number]
      @position = Coordinate.new(row: start_row, col: start_col)
    when :black
      start_row = 1
      start_col = [0, 1, 2, 3, 4, 5, 6, 7][number]
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

  def symbol
    if color == :white
      "♟"
    elsif color == :black
      "\u001b[30m\u265F"
    end
  end
end
