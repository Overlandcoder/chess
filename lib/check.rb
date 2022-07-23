module Check
  def remove_check_moves(piece = chosen_piece)
    current_row = piece.position.row
    current_col = piece.position.col
    moves_to_delete = []

    piece.possible_moves.each do |move|
      @board_copy = Marshal.load(Marshal.dump(board))
      simulate_move(current_row, current_col, move, piece)
      moves_to_delete << move if king_in_check? && !piece.is_a?(King)
      remove_king_checks
    end

    moves_to_delete.each { |move| piece.possible_moves.delete(move) }
  end

  def simulate_move(row, col, move, piece)
    @board_copy.place(row, col, nil)
    @board_copy.place(move[0], move[1], piece)
  end

  def king_in_check?(row = king.position.row, col = king.position.col)
    opponent_moves.any? { |move| move == [row, col] }
  end

  def remove_king_checks
    king.possible_moves.delete_if { |move| opponent_moves.include?(move) }
  end

  def opponent_moves
    possible_moves = []
    (0..7).each do |row|
      (0..7).each do |col|
        piece = @board_copy.square_at(row, col)
        next if piece.nil?
        next unless piece.color == opponent.color

        if piece.is_a?(Pawn)
          possible_moves << piece.capturing_moves_only
        else
          piece.generate_possible_moves(@board_copy)
          possible_moves << piece.possible_moves
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
