class KingsideCastle
  attr_reader :board, :color

  def initialize(board, color)
    @board, @color = board, color
    @castling_row = 7 if color == :white
    @castling_row = 0 if color == :black
  end

  def possible?
    return false unless rook && rook.can_castle

    kingside_squares_empty? && !kingside_squares_under_attack?
  end

  def rook
    piece = board.square_at(@castling_row, 7)
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
