require_relative 'player'
require_relative 'board'
require_relative 'piece'
require 'pry-byebug'

class Game
  attr_reader :board, :current_player, :player1, :player2

  # TYPES = ['rook', 'knight', 'bishop', 'queen', 'king']
  TYPES = ['rook']

  def initialize
    @board = Board.new
  end

  def setup
    intro_message
    @player1 = create_player(1, 'white')
    @player2 = create_player(2, 'black')
    pieces(player1.color, player1)
    pieces(player2.color, player2)
    board.attach_piece(player1.pieces)
    board.attach_piece(player2.pieces)
    board.display
  end

  def create_player(number, color)
    puts "\nPlayer #{number}, enter your name:"
    name = gets.chomp.capitalize
    # name = 'a'
    Player.new(name, color)
  end

  def pieces(color, player)
    TYPES.each { |type| create_piece(type, color, player, board) }
  end

  def create_piece(type, color, player, board, num  = 1)
    num = 7 if type == 'pawn'

    (0..num).each do |number|
      piece = Piece.for(type, color, number, board)
      player.add_piece(piece)
    end
  end

  def play_game
    setup
    @current_player = player1

    # until board.game_over?
      play_round
      @current_player = switch_turns
    # end
    conclusion
  end

  def play_round
    board.display
    player_turn
    piece_to_move_coordinates = choose_piece
    destination_coordinates = choose_destination
  end

  def switch_turns
    if current_player == player1
      @current_player = player2
      board.current_player = player2
    else
      @current_player = player1
      board.current_player = player1
    end
  end

  def player_turn
    puts "#{current_player}, it's your turn."
  end

  def choose_piece
    puts 'Select a piece to move:'
    user_input = gets.chomp.capitalize
    row = coordinates(user_input)[0]
    column = coordinates(user_input)[1]
    piece_coordinates = [row, column]

    return piece_coordinates if own_piece?(row, column)

    puts "That is your opponent's piece, please select your own piece!"
    choose_piece
  end

  def coordinates(piece)
    column_letter = piece[0, 1].to_sym
    columns = { A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7 }
    column = columns[column_letter]
    row = 8 - piece[1, 1].to_i
    [row, column]
  end

  def own_piece?(row, column)
    piece_to_move = board.square_at(row, column)
    piece_to_move.color == current_player.color
  end

  def choose_destination
    puts 'Enter the position to move the piece to:'
    user_input = gets.chomp.capitalize
    row = coordinates(user_input)[0]
    column = coordinates(user_input)[1]
    destination_coordinates = [row, column]

    return destination_coordinates if square_empty? || !own_piece?(row, column)

    puts 'Invalid move, please choose another square to move the piece to.'
  end

  def square_empty?(row, column)
    board.square_at(row, column).nil?
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

# game = Game.new
# game.setup
