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
    until player1.pieces.length.zero?
      board.display
      play_round
      @current_player = opponent
    end
    # conclusion
  end

  def play_round
    current_player.pieces.each { |piece| puts piece.symbol }
    player_turn
    piece_selection
    board.highlight_piece(piece_position.row, piece_position.col)
    piece_to_move.hold_opponent_pieces(opponent.pieces) if piece_to_move.symbol.include?('♚')
    piece_to_move.generate_possible_moves
    board.highlight_possible_moves(piece_to_move.moves)
    @destination = choose_destination
    remove_opponent_piece
    update_board
    update_piece_position
    clear_old_position
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

  def player_turn
    puts "#{current_player.color.capitalize}, it's your turn."
  end

  def choose_piece
    loop do
      puts 'Select a piece to move:'
      user_input = gets.chomp.capitalize
      row, col = coordinates(user_input)

      return Coordinate.new(row: row, col: col) if own_piece?(row, col)

      puts 'Please select your own piece!'
    end
  end

  def choose_destination
    puts 'Enter the position to move the piece to:'
    user_input = gets.chomp.capitalize
    row, col = coordinates(user_input)
    destination_coordinates = Coordinate.new(row: row, col: col)
    piece_to_move.set_destination(destination_coordinates)

    return destination_coordinates if piece_to_move.valid_move? &&
                                      nil_or_opponent?(row, col)

    puts 'Invalid move, please choose another square:'
    choose_destination
  end

  def coordinates(input)
    column_letter = input[0, 1].to_sym
    columns = { A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7 }
    col = columns[column_letter]
    row = 8 - input[1, 1].to_i
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

  def square_empty?(row, col)
    board.square_at(row, col).nil?
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
