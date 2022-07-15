require_relative 'player'
require_relative 'board'
require_relative 'piece'
require_relative 'coordinate'
require 'pry-byebug'

class Game
  attr_reader :board, :current_player, :player1, :player2, :piece_position,
              :destination, :chosen_piece

  TYPES = [:rook, :knight, :bishop, :queen, :king, :pawn]

  def initialize
    @board = Board.new
  end

  def setup
    intro_message
    @player1 = create_player(:white)
    @player2 = create_player(:black)
    pieces(player1.color, player1)
    pieces(player2.color, player2)
    board.attach_pieces(board.white_pieces)
    board.attach_pieces(board.black_pieces)
  end

  def create_player(color)
    Player.new(color)
  end

  def pieces(color, player)
    TYPES.each { |type| create_piece(type, color, board) }
  end

  def create_piece(type, color, board, num = 1)
    num = 7 if type == :pawn
    num = 0 if type == :king || type == :queen

    (0..num).each do |number|
      piece = Piece.for(type, color, number, board)
      board.add_piece(piece)
    end
  end

  def play_game
    setup
    @current_player = player1

    # this 'until' condition will be changed later
    play_round
    # conclusion
  end

  def play_round
    loop do
      board.display
      piece_selection
      board.highlight_piece(chosen_piece.position.row, chosen_piece.position.col)
      chosen_piece.generate_possible_moves
      remove_check_moves
      add_castling_moves if chosen_piece.is_a?(King)
      board.highlight_possible_moves(chosen_piece.possible_moves)
      @destination = choose_destination
      castling?
      en_passant_capture
      make_move
    p board.pieces(current_player.color).length
      promote_pawn if chosen_piece.is_a?(Pawn) && chosen_piece.can_be_promoted?
      @current_player = opponent
    end
    # break if chosen_piece.respond_to?(:checkmate?) && chosen_piece.checkmate?
  end

  def reselect
    board.display
    piece_selection
    board.highlight_piece(chosen_piece.position.row, chosen_piece.position.col)
    chosen_piece.generate_possible_moves
    remove_check_moves
    board.highlight_possible_moves(chosen_piece.possible_moves)
    return if chosen_piece.respond_to?(:checkmate?) && chosen_piece.checkmate?
    @destination = choose_destination
  end

  def make_move
    reset_last_moved_pawn
    remove_opponent_piece
    update_board
    update_piece_position
    clear_old_position
    last_moved_pawn
  end

  def last_moved_pawn
    return unless chosen_piece.is_a?(Pawn)

    chosen_piece.moved_last = true
    current_player.last_moved_pawn = chosen_piece
  end

  def reset_last_moved_pawn
    return unless current_player.last_moved_pawn
    return unless chosen_piece != current_player.last_moved_pawn

    current_player.last_moved_pawn.moved_last = false
  end

  def promote_pawn
    puts 'Time to promote this pawn! Enter one of the following piece names...'
    puts 'queen, rook, bishop or knight:'
    piece_type = gets.chomp.to_sym
    create_piece(piece_type, current_player.color, board, 0)
    new_piece = board.pieces(current_player.color)[-1]
    board.update(chosen_piece.position.row, chosen_piece.position.col, new_piece)
    board.remove_piece(chosen_piece)
  end

  def king
    case current_player.color
    when :white
      board.white_pieces.find { |piece| piece.is_a?(King)}
    when :black
      board.black_pieces.find { |piece| piece.is_a?(King)}
    end
  end

  def piece_selection
    @piece_position = choose_piece
    @chosen_piece = board.square_at(piece_position.row, piece_position.col)
  end

  def remove_opponent_piece
    return if board.square_at(destination.row, destination.col).nil?

    piece_to_remove = board.square_at(destination.row, destination.col)
    board.remove_piece(piece_to_remove)
  end

  def clear_old_position
    board.update(piece_position.row, piece_position.col, nil)
    board.update(@castling_row, 7, nil) if king.is_castling && @castling_kingside
    board.update(@castling_row, 0, nil) if king.is_castling && @castling_queenside
  end

  def opponent
    current_player == player1 ? player2 : player1
  end

  def choose_piece
    puts "#{current_player.color.capitalize}, select a piece to move (enter 'retry' to reselect):"
    user_input = gets.chomp.capitalize
    row, col = coordinates(user_input)
    
    return Coordinate.new(row: row, col: col) if own_piece?(row, col)

    puts 'Please select your own piece!'
    choose_piece
  end

  def choose_destination
    puts 'Enter the position to move the piece to:'
    user_input = gets.chomp.capitalize
    return reselect if user_input == 'Retry'

    row, col = coordinates(user_input)
    destination_coordinates = Coordinate.new(row: row, col: col)
    chosen_piece.set_destination(destination_coordinates)

    return destination_coordinates if chosen_piece.valid_move? &&
                                      nil_or_opponent?(row, col)

    puts 'Invalid move, please choose another square:'
    choose_destination
  end

  def remove_check_moves
    current_row = chosen_piece.position.row
    current_col = chosen_piece.position.col
    moves_to_delete = []

    chosen_piece.possible_moves.each do |move|
    @board_copy = Marshal.load(Marshal.dump(board))
      simulate_move(current_row, current_col, move)
      moves_to_delete << move if king_in_check? && !chosen_piece.is_a?(King)
      remove_king_checks
    end

    moves_to_delete.each { |move| chosen_piece.possible_moves.delete(move) }
  end

  def simulate_move(row, col, move)
    @board_copy.update(row, col, nil)
    @board_copy.update(move[0], move[1], chosen_piece)
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
          piece.generate_possible_moves
          possible_moves << piece.possible_moves
        end
      end
    end
    possible_moves.flatten(1)
  end

  def r_rook
    piece = board.square_at(@castling_row, 7)
    return nil if piece.nil?

    piece if piece.is_a?(Rook)
  end

  def l_rook
    piece = board.square_at(@castling_row, 0)
    return nil if piece.nil?

    piece if piece.is_a?(Rook)
  end

  def add_castling_moves
    return if king_in_check? || !king.moves_made.zero?

    @castling_row = 7 if current_player.color == :white
    @castling_row = 0 if current_player.color == :black

    king.possible_moves << [@castling_row, 6] if kingside_castle
    king.possible_moves << [@castling_row, 2] if queenside_castle
  end

  def castling?
    king.is_castling = false
    return false unless chosen_piece == king

    if (kingside_castle && king.destination.row == @castling_row &&
      king.destination.col == 6)
      @castling_kingside = true
      king.is_castling = true
    elsif (queenside_castle && king.destination.row == @castling_row &&
      king.destination.col == 2)
      @castling_queenside = true
      king.is_castling = true
    end
  end

  def kingside_castle
    return false unless r_rook && r_rook.moves_made.zero?

    (board.square_at(@castling_row, 5).nil? && board.square_at(@castling_row, 6).nil?) &&
    (!king_in_check?(@castling_row, 5) && !king_in_check?(@castling_row, 6))
  end

  def queenside_castle
    return false unless l_rook && l_rook.moves_made.zero?

    (board.square_at(@castling_row, 3).nil? && board.square_at(@castling_row, 2).nil? &&
    board.square_at(@castling_row, 1).nil?) && (!king_in_check?(@castling_row, 3) &&
    !king_in_check?(@castling_row, 2) && !king_in_check?(@castling_row, 1))
  end

  def en_passant_capture
    return unless chosen_piece.is_a?(Pawn)
    return if destination.col == chosen_piece.position.col
    return unless board.square_at(destination.row, destination.col).nil?

    piece_to_remove = board.square_at(chosen_piece.position.row, chosen_piece.destination.col)

    return unless piece_to_remove.is_a?(Pawn) && piece_to_remove.moved_last

    board.remove_piece(piece_to_remove)
    board.update(piece_to_remove.position.row, piece_to_remove.position.col, nil)
  end

  def checkmate?
    board.pieces(current_player.color)
  end

  def coordinates(input)
    column_letter = input[0].to_sym
    columns = { A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7 }
    col = columns[column_letter]
    row = 8 - input[1].to_i
    [row, col]
  end

  def own_piece?(row, col)
    board.square_at(row, col) &&
    board.square_at(row, col).color == current_player.color
  end

  def nil_or_opponent?(row, col)
    board.square_at(row, col).nil? ||
      board.square_at(row, col).color != current_player.color
  end

  def update_board
    board.update(@castling_row, 5, r_rook) if king.is_castling && @castling_kingside
    board.update(@castling_row, 3, l_rook) if king.is_castling && @castling_queenside
    board.update(destination.row, destination.col, chosen_piece)
  end

  def update_piece_position
    r_rook.update_position(@castling_row, 5) if king.is_castling && @castling_kingside
    l_rook.update_position(@castling_row, 3) if king.is_castling && @castling_queenside
    chosen_piece.update_position
  end

  def intro_message
    puts <<~INTRO
Welcome to Chess!
This is a two-player game. To give you an idea of how the grid positioning
works, the bottom-left rook is located at A1. When asked to choose a piece
to move, enter A1 or a1 for that rook, for example. Good luck and have fun!
    INTRO
  end
end

Game.new.play_game
