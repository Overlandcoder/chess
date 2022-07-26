class King < Piece
  POSSIBLE_MOVES = [[-1, -1], [0, -1], [1, -1], [1, 0],
                    [1, 1], [0, 1], [-1, 1], [-1, 0]].freeze

  def initialize(color, number)
    @color = color
    @number = number
    create_coordinate
    @possible_moves = []
    @moves_made = 0
  end

  def to_s
    color == :white ? "\u001b[37;1m\u265A" : "\u001b[30m\u265A"
  end

  def starting_positions
    { white: [7, 4], black: [0, 4] }[color]
  end

  def create_coordinate
    start_row, start_col = starting_positions
    @position = Coordinate.new(row: start_row, col: start_col)
  end

  def valid_move?
    @possible_moves.include?([destination.row, destination.col])
  end

  def update_position(row = destination.row, col = destination.col)
    position.update_row(row)
    position.update_col(col)
    @moves_made += 1
  end

  def castling_kingside?(board)
    return false unless destination.col == 6 && moves_made.zero?

    KingsideCastle.new(board, color).possible?
  end

  def castling_queenside?(board)
    return false unless destination.col == 3 && moves_made.zero?

    QueensideCastle.new(board, color).possible?
  end

  def generate_possible_moves(board, checking_for_check = false)
    @possible_moves.clear

    POSSIBLE_MOVES.each do |move|
      row = position.row + move[0]
      col = position.col + move[1]

      next unless row.between?(0, 7) && col.between?(0, 7) &&
                  board.nil_or_opponent?(row, col, color)

      @possible_moves << [row, col]
    end
    add_castling_moves(board) unless checking_for_check
    Evaluation.new(board, color).remove_check_moves(self) unless checking_for_check
  end

  def add_castling_moves(board)
    return if king_in_check?(board) || !moves_made.zero?

    add_kingside_castling_moves(board)
    add_queenside_castling_moves(board)
  end

  def king_in_check?(board)
    Evaluation.new(board, color).king_in_check?
  end

  def add_kingside_castling_moves(board)
    return unless KingsideCastle.new(board, color).possible?

    possible_moves << [position.row, 6]
  end

  def add_queenside_castling_moves(board)
    return unless QueensideCastle.new(board, color).possible?

    possible_moves << [position.row, 2]
  end
end
