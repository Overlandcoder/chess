class KingsideCastle
  attr_reader :board, :color, :king

  def initialize(board, color, king)
    @board, @color, @king = board, color, king
    @castling_row = 7 if color == :white
    @castling_row = 0 if color == :black
  end

  def possible?
    return false unless rook && rook.moves_made.zero?

    kingside_squares_empty? && !kingside_squares_under_attack?
  end

  def rook
    piece = board.square_at(@castling_row, 7)
    # can remove this eventually
    piece if piece.is_a?(Rook)
  end

  def kingside_squares_empty?
    board.square_at(@castling_row, 5).nil? &&
      board.square_at(@castling_row, 6).nil?
  end

  def kingside_squares_under_attack?
    Evaluation.new(board, color).king_in_check?(@castling_row, 5) ||
      Evaluation.new(board, color).king_in_check?(@castling_row, 6)
  end
end
