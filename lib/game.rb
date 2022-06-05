require_relative 'player'
require_relative 'board'
require_relative 'piece'
require 'pry-byebug'

class Game
  attr_reader :board, :current_player, :player1, :player2

  TYPES = ['rook', 'knight', 'bishop', 'queen', 'king']

  def initialize
    @board = Board.new
  end

  def setup
    intro_message
    @player1 = create_player(1, 'white')
    @player2 = create_player(2, 'black')
    pieces(player1.color, player1)
    pieces(player2.color, player2)
    board.add_pieces_to_display(player1.pieces)
    board.add_pieces_to_display(player2.pieces)
    board.display
  end

  def create_player(number, color)
    puts "\nPlayer #{number}, enter your name:"
    # name = gets.chomp.capitalize
    name = 'a'
    Player.new(name, color)
  end

  def pieces(color, player)
    TYPES.each { |type| create_piece(type, color, player) }
  end

  def create_piece(type, color, player, num  = 1)
    num = 7 if type == 'pawn'

    (0..num).each do |number|
      piece = Piece.for(type, color, number)
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
    piece_to_move = choose_piece
    piece_coordinates = get_coordinates(piece_to_move)
    destination = solicit_move
    destination_coordinates = get_coordinates(destination)
  end

  def switch_turns
    current_player == player1 ? player2 : player1
  end

  def player_turn
    puts "#{current_player}, it's your turn."
  end

  def choose_piece
    puts 'Please select a piece to move:'
    gets.chomp.capitalize
  end

  def get_coordinates(piece)
    column_letter = piece[0, 1].to_sym
    columns = { A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7 }
    column = columns[column_letter]
    row = 8 - piece[1, 1].to_i
    [row, column]
  end

  def solicit_move
    puts 'Enter the position that you want to move the piece to:'
    gets.chomp.capitalize
  end

  def intro_message
    puts <<~INTRO
Welcome to Chess!

This is a two-player game. To give you an idea of how the grid positioning
works, the bottom-left rook is located at A1. Good luck and have fun!
    INTRO
  end
end

game = Game.new
game.setup
