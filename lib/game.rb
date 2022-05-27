require_relative 'player'

class Game
  def setup
    intro_message
    @player1 = create_player(1)
    @player2 = create_player(2)
  end

  def intro_message
    puts <<~HEREDOC
Welcome to Chess!

This is a two-player game. The game begins after each player's name has been entered.

Good luck and have fun!
    HEREDOC
  end

  def create_player(number)
    puts "\nPlayer #{number}, enter your name:"
    name = gets.chomp.capitalize
    Player.new(name)
  end
end