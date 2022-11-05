class BoardToFen
  def initialize(board, current_player, kings, rooks)
    @board = board
    @current_player = current_player
    @kings = kings
    @rooks = rooks
  end

  def convert
    @fen_string = ''
    (0..7).each do |row_number|
      (0..7).each do |col_number|
        square = @board.square_at(row_number, col_number)
        square_to_fen(square)
        @fen_string += '/' if col_number == 7 && row_number < 7
      end
    end
    @fen_string += current_player_to_fen
    add_castling_rights(:white)
    add_castling_rights(:black)
    @fen_string
  end

  def square_to_fen(square)
    if square
      @fen_string += piece_to_fen(square)
    elsif @fen_string[-1].to_i.positive?
      @fen_string[-1] = (@fen_string[-1].to_i + 1).to_s
    else
      @fen_string += '1'
    end
  end

  def piece_to_fen(piece)
    case piece
    when Rook
      piece.color == :white ? 'R' : 'r'
    when Bishop
      piece.color == :white ? 'B' : 'b'
    when Knight
      piece.color == :white ? 'N' : 'n'
    when Queen
      piece.color == :white ? 'Q' : 'q'
    when King
      piece.color == :white ? 'K' : 'k'
    when Pawn
      piece.color == :white ? 'P' : 'p'
    end
  end

  def current_player_to_fen
    @current_player.color == :white ? ' w ' : ' b '
  end

  # This is not technically for castling rights, it's just to keep track of
  # can_castle, which indicates whether a castling piece has moved or not.
  # This is the simplest/quickest way I thought of for handling this, for now.
  def add_castling_rights(color)
    return unless king(color).can_castle

    k_letter = color == :white ? 'K' : 'k'
    q_letter = color == :white ? 'Q' : 'q'
    @fen_string += k_letter if r_rook(color) && r_rook(color).can_castle
    @fen_string += q_letter if l_rook(color) && l_rook(color).can_castle
  end

  def king(color)
    @kings.find { |king| king.color == color }
  end

  def r_rook(color)
    row = color == :white ? 7 : 0

    @rooks.find do |rook|
      rook.color == color && rook.position.row == row &&
                    rook.position.col == 7
    end
  end

  def l_rook(color)
    row = color == :white ? 7 : 0

    @rooks.find do |rook|
      rook.color == color && rook.position.row == row &&
                    rook.position.col == 0
    end
  end
end
