class Knight < Piece
  POSSIBLE_MOVES = [[1, 2], [1, -2], [-1, 2], [-1, -2],
                    [2, 1], [2, -1], [-2, 1], [-2, -1]].freeze

  def initialize(color, number)
    @color = color
    @number = number
    create_coordinate
    @possible_moves = []
  end

  def to_s
    color == :white ? '♞' : "\u001b[30m♞"
  end

  def starting_positions
    { white: [[7, 1], [7, 6]], black: [[0, 1], [0, 6]] }[color]
  end

  def create_coordinate
    start_row, start_col = starting_positions[number]
    @position = Coordinate.new(row: start_row, col: start_col)
  end

  def valid_move?(row = destination.row, col = destination.col)
    POSSIBLE_MOVES.any? do |move|
      position.row + move[0] == row &&
        position.col + move[1] == col
    end
  end

  def update_position(row = destination.row, col = destination.col)
    position.update_row(row)
    position.update_col(col)
  end

  def generate_possible_moves(board, checking_for_check = false)
    @possible_moves.clear

    (0..7).each do |row|
      (0..7).each do |col|
        next unless valid_move?(row, col) &&
                    board.nil_or_opponent?(row, col, color)

        @possible_moves << [row, col]
      end
    end
    Evaluation.new(board, color).remove_check_moves(self) unless checking_for_check
  end
end
