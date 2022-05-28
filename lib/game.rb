require_relative 'player'
require_relative 'board'

class Game
  attr_reader :board, :current_player

  def initialize
    @board = Board.new
  end

  def setup
    intro_message
    @player1 = create_player(1, 'white')
    @player2 = create_player(2, 'black')
    create_pieces(player1)
    create_pieces(player2)
  end

  def intro_message
    puts <<~INTRO
Welcome to Chess!

This is a two-player game. The game begins after each player's name has been entered.

Good luck and have fun!
    INTRO
  end

  def create_player(number, color)
    puts "\nPlayer #{number}, enter your name:"
    name = gets.chomp.capitalize
    Player.new(name, color)
  end

  def create_pieces(player)

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
end
