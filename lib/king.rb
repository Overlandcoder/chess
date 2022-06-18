class King
  attr_reader :color, :number, :position, :destination, :moves, :board,
              :opponent_pieces

  POSSIBLE_MOVES = [[-1, -1], [0, -1], [1, -1], [1, 0],
                    [1, 1], [0, 1], [-1, 1], [-1, 0]]

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
    @moves_made = 0
  end

  def create_coordinate
    case color
    when :white
      start_row, start_col = [7, 4]
      @position = Coordinate.new(row: start_row, col: start_col)
    when :black
      start_row, start_col = [0, 4]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def valid_move?(row = destination.row, col = destination.col)
    POSSIBLE_MOVES.any? do |move|
      position.row + move[0] == row &&
      position.col + move[1] == col
    end
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position
    position.update_row(destination.row)
    position.update_col(destination.col)
    @possible_moves.clear
    @possible_moves_made += 1
  end
  
  def generate_possible_moves(opponent = false)
    (0..7).each do |row|
      (0..7).each do |col|
        @possible_moves << [row, col] if valid_move?(row, col) &&
                                board.nil_or_opponent?(row, col, color) &&
                                (!in_check?(row, col) unless opponent)
      end
    end
  end

  def in_check?(row, col)
    @opponent_moves.any? { |move| move == [row, col] }
  end

  def checkmate?
    if @possible_moves.empty?
      puts 'Checkmate.'
      return true
    else
      return false
    end
  end

  def hold_opponent_moves(opponent_moves)
    @opponent_moves = opponent_moves
  end

  def symbol
    if color == :white
      "\u001b[37;1m♚"
    elsif color == :black
      "\u001b[30m♚"
    end
  end
end
