module Check
  def remove_check_moves(current_piece)
    @current_piece = current_piece
    current_row = @current_piece.position.row
    current_col = @current_piece.position.col
    moves_to_delete = []

    @current_piece.possible_moves.each do |move|
      @board_copy = Marshal.load(Marshal.dump(board))
      simulate_move(current_row, current_col, move, @current_piece)
      moves_to_delete << move if king_in_check? && !@current_piece.is_a?(King)
      remove_king_checks
    end
#
    moves_to_delete.each { |move| @current_piece.possible_moves.delete(move) }
  end

  def king
    board.pieces(@current_piece.color).find { |piece| piece.is_a?(King) }
  end

  def simulate_move(row, col, move, piece)
    @board_copy.place(row, col, nil)
    @board_copy.place(move[0], move[1], piece)
  end

  def king_in_check?
    row = king.position.row
    col = king.position.col
    opponent_moves.any? { |opponent_move| opponent_move == [row, col] }
  end

  def remove_king_checks
    king.possible_moves.delete_if { |king_move|
      opponent_moves.include?(king_move)
    }
  end

  def opponent_moves
    possible_moves = []
    (0..7).each do |row|
      (0..7).each do |col|
        opponent_piece = @board_copy.square_at(row, col)
        next if opponent_piece.nil?
        next unless opponent_piece.color == @current_piece.color

        if opponent_piece.is_a?(Pawn)
          possible_moves << opponent_piece.capturing_moves_only
        else
          opponent_piece.generate_possible_moves(@board_copy)
          possible_moves << opponent_piece.possible_moves
        end
      end
    end
    possible_moves.flatten(1)
  end

  def checkmate?
    no_moves_left? && king_in_check?
  end

  def no_moves_left?
    board.pieces(current_player.color).all? do |piece|
      piece.generate_possible_moves(board)
      remove_check_moves(piece)
      piece.possible_moves.length.zero?
    end
  end

  def stalemate?
    no_moves_left? && !king_in_check?
  end
end
