class Evaluation
  attr_reader :board, :color

  def initialize(board, color)
    @board, @color = board, color
  end

  def remove_check_moves(current_piece)
    current_row = current_piece.position.row
    current_col = current_piece.position.col
    moves_to_delete = []

    current_piece.possible_moves.each do |move|
      @board_copy = Marshal.load(Marshal.dump(board))
      simulate_move(current_row, current_col, move, current_piece)
      moves_to_delete << move if king_in_check? && !current_piece.is_a?(King)
      remove_king_checks
    end
    moves_to_delete.each { |move| current_piece.possible_moves.delete(move) }
  end

  def king
    board.pieces(@color).find { |piece| piece.is_a?(King) }
  end

  def simulate_move(row, col, move, current_piece)
    @board_copy.place(row, col, nil)
    @board_copy.place(move[0], move[1], current_piece)
  end

  def king_in_check?
    row = king.position.row
    col = king.position.col
    opponent_moves_list.any? { |opponent_move| opponent_move == [row, col] }
  end

  def remove_king_checks
    king.possible_moves.delete_if { |king_move|
      opponent_moves_list.include?(king_move)
    }
  end

  def opponent_moves_list
    @board_copy = Marshal.load(Marshal.dump(board))
    opponent_moves = []
    (0..7).each do |row|
      (0..7).each do |col|
        opponent_piece = @board_copy.square_at(row, col)
        next if opponent_piece.nil? || opponent_piece.color == @color

        if opponent_piece.is_a?(Pawn)
          opponent_moves << opponent_piece.capturing_moves_only
        else
          opponent_piece.generate_possible_moves(@board_copy, true)
          opponent_moves << opponent_piece.possible_moves
        end
      end
    end
    opponent_moves.flatten(1)
  end

  def checkmate?
    no_moves_left? && king_in_check?
  end

  def no_moves_left?
    board.pieces(@color).all? do |piece|
      piece.generate_possible_moves(@board)
      piece.possible_moves.length.zero?
    end
  end

  def stalemate?
    no_moves_left? && !king_in_check?
  end
end
