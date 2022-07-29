class BoardToFen
  def initialize(board, active_player)
    @board, @active_player = board, active_player
  end

  def convert
    @fen_string = ''
    (0..7).each do |row_number|
      (0..7).each do |col_number|
        square = @board.square_at(row_number, col_number)
        square_to_fen(square)
        @fen_string += '/' if col_number == 7 && row_number < 7
        p @fen_string
      end
    end
    @fen_string += active_player_to_fen
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

  def active_player_to_fen
    @active_player.color == :white ? ' w' : ' b'
  end
end
