class Queen < Piece
  POSSIBLE_MOVES = [[-1, 0], [0, 1], [1, 0], [0, -1],
                    [-1, 1], [1, -1], [1, 1], [-1, -1]].freeze

  def initialize(color, number)
    @color, @number = color, number
    create_coordinate
    @possible_moves = []
  end

  def starting_positions
    { white: [7, 3], black: [0, 3] }[color]
  end

  def create_coordinate
    start_row, start_col = starting_positions
    @position = Coordinate.new(row: start_row, col: start_col)
  end

  def to_s
    color == :white ? "\u001b[37;1m\u265B" : "\u001b[30m\u265B"
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
  end

  def generate_possible_moves(board, checking_for_check = false)
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
    Evaluation.new(board, color).remove_check_moves(self) unless checking_for_check
  end
end
