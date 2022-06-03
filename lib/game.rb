require_relative 'player'
require_relative 'board'
require_relative 'piece'
require 'pry-byebug'

class Game
  attr_reader :board, :current_player, :player1, :player2

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

  def create_piece(type, color, player, i = 1)
    i = 7 if type == 'pawn'

    (0..i).each do |number|
      piece = Piece.for(type, color, number)
      player.add_piece(piece)
    end
  end

  def play_game
    setup

    until board.game_over?
      play_round
      @current_player = switch_turns
    end
    conclusion
  end

  def play_round
    board.display
  end

  def switch_turns
    current_player == player1 ? player2 : player1
  end

  def intro_message
    puts <<~INTRO
Welcome to Chess!

This is a two-player game. The game begins after each player's name has been entered.

Good luck and have fun!
    INTRO
  end
end

game = Game.new.setup
