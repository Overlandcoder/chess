class Queen
  attr_reader :color, :number, :position, :destination, :board,
              :possible_moves, :title

  attr_accessor :possible_moves

  POSSIBLE_MOVES = [[-1, 0], [0, 1], [1, 0], [0, -1],
                    [-1, 1], [1, -1], [1, 1], [-1, -1]]

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
    @title = 'Queen'
  end

  def create_coordinate
    case color
    when :white
      start_row, start_col = [7, 3]
      @position = Coordinate.new(row: start_row, col: start_col)
    when :black
      start_row, start_col = [0, 3]
      @position = Coordinate.new(row: start_row, col: start_col)
    end
  end

  def valid_move?
    @possible_moves.include?([destination.row, destination.col])
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position(row = destination.row, col = destination.col)
    position.update_row(row)
    position.update_col(col)
  end

  def generate_possible_moves
    @possible_moves.clear

    POSSIBLE_MOVES.each do |move|
      row = position.row
      col = position.col
      loop do
        row += move[0]
        col += move[1]
        break unless row.between?(0, 7) && col.between?(0, 7) &&
                    board.nil_or_opponent?(row, col, color)
                    @possible_moves << [row, col]
        break unless board.square_at(row, col).nil?
      end
    end
  end

  def symbol
    if color == :white
      "\u001b[37;1m\u265B"
    elsif color == :black
      "\u001b[30m\u265B"
    end
  end
end
