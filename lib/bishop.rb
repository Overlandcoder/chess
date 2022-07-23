class Bishop < Piece
  POSSIBLE_MOVES = [[-1, 1], [1, -1], [1, 1], [-1, -1]].freeze

  def initialize(color, number)
    @color = color
    @number = number
    create_coordinate
    @possible_moves = []
  end

  def to_s
    color == :white ? "\u001b[37;1m\u265D" : "\u001b[30m\u265D"
  end

  def starting_positions
    { white: [[7, 2], [7, 5]], black: [[0, 2], [0, 5]] }[color]
  end

  def create_coordinate
    start_row, start_col = starting_positions[number]
    @position = Coordinate.new(row: start_row, col: start_col)
  end

  def valid_move?
    @possible_moves.include?([destination.row, destination.col])
  end

  def update_position(row = destination.row, col = destination.col)
    position.update_row(row)
    position.update_col(col)
  end

  def generate_possible_moves(board)
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
