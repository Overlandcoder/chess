class QueensideCastle
  attr_reader :board, :color

  def initialize(board, color)
    @board, @color = board, color
    @castling_row = 7 if color == :white
    @castling_row = 0 if color == :black
  end

  def possible?
    return false unless rook && rook.can_castle

    queenside_squares_empty? && !queenside_squares_under_attack?
  end

  def rook
    piece = board.square_at(@castling_row, 0)
    piece if piece.is_a?(Rook)
  end

  def queenside_squares_empty?
    board.square_at(@castling_row, 3).nil? &&
      board.square_at(@castling_row, 2).nil? &&
        board.square_at(@castling_row, 1).nil?
  end

  def queenside_squares_under_attack?
    Evaluation.new(board, color).king_in_check?(@castling_row, 3) ||
      Evaluation.new(board, color).king_in_check?(@castling_row, 2) ||
        Evaluation.new(board, color).king_in_check?(@castling_row, 1)
  end
end
