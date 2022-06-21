require_relative 'player'
require_relative 'board'
require_relative 'piece'
require_relative 'coordinate'
require 'pry-byebug'

class Game
  attr_reader :board, :current_player, :player1, :player2, :piece_position,
              :destination, :piece_to_move

  TYPES = [:rook, :knight, :bishop, :queen, :king]

  def initialize
    @board = Board.new
  end

  def setup
    intro_message
    @player1 = create_player(:white)
    @player2 = create_player(:black)
    pieces(player1.color, player1)
    pieces(player2.color, player2)
    board.attach_piece(player1.pieces)
    board.attach_piece(player2.pieces)
  end

  def create_player(color)
    Player.new(color)
  end

  def pieces(color, player)
    TYPES.each { |type| create_piece(type, color, player, board) }
  end

  def create_piece(type, color, player, board, num = 1)
    num = 7 if type == :pawn
    num = 0 if type == :king || type == :queen

    (0..num).each do |number|
      piece = Piece.for(type, color, number, board)
      player.add_piece(piece)
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
      board.highlight_piece(piece_position.row, piece_position.col)
      piece_to_move.generate_possible_moves
      remove_check_moves
      board.highlight_possible_moves(piece_to_move.possible_moves)
      break if piece_to_move.respond_to?(:checkmate?) && piece_to_move.checkmate?
      @destination = choose_destination
      remove_opponent_piece
      update_board
      update_piece_position
      clear_old_position
      @current_player = opponent
    end
  end

  def king
    current_player.pieces.find { |piece| piece.symbol.include?('♚') }
  end

  def piece_selection
    @piece_position = choose_piece
    @piece_to_move = board.square_at(piece_position.row, piece_position.col)
  end

  def remove_opponent_piece
    return if board.square_at(destination.row, destination.col).nil?

    piece_to_remove = board.square_at(destination.row, destination.col)
    opponent.remove_piece(piece_to_remove)
  end

  def clear_old_position
    board.update_board(piece_position.row, piece_position.col, nil)
  end

  def opponent
    current_player == player1 ? player2 : player1
  end

  def choose_piece
    puts "#{current_player.color.capitalize}, select a piece to move:"
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
    piece_to_move.set_destination(destination_coordinates)

    return destination_coordinates if piece_to_move.valid_move? &&
                                      nil_or_opponent?(row, col)

    puts 'Invalid move, please choose another square:'
    choose_destination
  end

  def reselect
    board.display
    piece_selection
    board.highlight_piece(piece_position.row, piece_position.col)
    piece_to_move.generate_possible_moves
    remove_check_moves
    board.highlight_possible_moves(piece_to_move.possible_moves)
    return if piece_to_move.respond_to?(:checkmate?) && piece_to_move.checkmate?
    @destination = choose_destination
  end

  def remove_check_moves
    current_row = piece_to_move.position.row
    current_col = piece_to_move.position.col
    moves_to_delete = []
    
    piece_to_move.possible_moves.each do |move|
      moves_to_delete << move if king_in_check? unless piece_to_move.title == 'King'
    end
    remove_king_check_moves
    moves_to_delete.each { |move| piece_to_move.possible_moves.delete(move) }
  end

  def remove_check_moves_old
    current_row = Marshal.load(Marshal.dump(piece_to_move.position.row))
    current_col = Marshal.load(Marshal.dump(piece_to_move.position.col))
    moves_to_delete = []
    
    piece_to_move.possible_moves.each do |move|
      opponent_piece_shallow = board.square_at(move[0], move[1])
      return if opponent_piece_shallow.nil? && !king_in_check?
      opponent_piece = Marshal.load(Marshal.dump(opponent_piece_shallow))
      opponent.hold_piece(opponent_piece) if opponent_piece
      simulate_move(current_row, current_col, move, opponent_piece_shallow)
      moves_to_delete << move if king_in_check?
      revert_move(current_row, current_col, move)
      opponent.clear_piece_held
    end

    moves_to_delete.each { |move| piece_to_move.possible_moves.delete(move) }
  end

  def simulate_move(row, col, move, opponent_piece)
    board.update_board(row, col, nil)
    opponent.remove_piece(opponent_piece)
    piece_to_move.update_position(move[0], move[1])
    board.update_board(move[0], move[1], piece_to_move)
  end

  def revert_move(row, col, move)
    piece_to_move.update_position(row, col)
    board.update_board(move[0], move[1], opponent.piece_held)
    board.update_board(row, col, piece_to_move)
    opponent.add_piece(opponent.piece_held)
  end

  def must_remove_check(position)
    if piece_to_move.possible_moves.include?(position)
      piece_to_move.possible_moves = [position]
    end
  end

  def remove_king_check_moves
    opponent_moves = generate_opponent_moves

    opponent_moves.any? do |opponent_move|
      king.possible_moves.any? do |king_move|
        king_move == opponent_move
        king.possible_moves.delete(king_move)
      end
    end
  end

  def king_in_check?
    opponent.pieces.any? do |piece|

      piece_moves = generate_piece_moves(piece)
      piece_moves.any? do |move|
        if move == [king.position.row, king.position.col]
          must_remove_check([piece.position.row, piece.position.col])
          piece_to_move.possible_moves.none? do |piece_move|
            piece_move == [piece.position.row, piece.position.col]
          end
        end
      end
    end
  end

  def generate_piece_moves(piece)
    possible_moves = []

    if piece == king
      piece.generate_possible_moves(true)
    else
      piece.generate_possible_moves
    end
    possible_moves << piece.possible_moves
    possible_moves.flatten(1)
  end

  def generate_opponent_moves
    possible_moves = []
    opponent.pieces.each do |piece|
      if piece == king
        piece.generate_possible_moves(true)
      else
        piece.generate_possible_moves
      end
      possible_moves << piece.possible_moves
    end
    possible_moves.flatten(1)
  end

  def generate_opponent_positions
    positions = []

    opponent.pieces.each do |piece|
      row = piece.position.row
      col = piece.position.col
      positions << [row, col]
    end
    positions
  end

  def coordinates(input)
    column_letter = input[0].to_sym
    columns = { A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7 }
    col = columns[column_letter]
    row = 8 - input[1].to_i
    [row, col]
  end

  def own_piece?(row, col)
    board.square_at(row, col).color == current_player.color
  end

  def nil_or_opponent?(row, col)
    board.square_at(row, col).nil? ||
      board.square_at(row, col).color != current_player.color
  end

  def update_board
    board.update_board(destination.row, destination.col, piece_to_move)
  end

  def update_piece_position
    piece_to_move.update_position
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
