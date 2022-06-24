class Pawn
  attr_reader :color, :number, :position, :destination, :board, :title,
              :possible_moves, :moves_made

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
    @title = 'Pawn'
    @moves_made = 0
    @moves = [[-1, 0], [-2, 0]] if color == :white
    @moves = [[1, 0], [2, 0]] if color == :black
  end

  def create_coordinate
    case color
    when :white
      start_col = [0, 1, 2, 3, 4, 5, 6, 7][number]
      @position = Coordinate.new(row: 2, col: start_col)
    when :black
      start_col = [0, 1, 2, 3, 4, 5, 6, 7][number]
      @position = Coordinate.new(row: 1, col: start_col)
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
    @moves_made += 1
  end

  def generate_possible_moves
    @possible_moves.clear
    remove_double_moves

    @moves.each do |move|
      row = position.row + move[0]
      col = position.col + move[1]
      @possible_moves << [row, col] if row.between?(0, 7) && col.between?(0, 7) &&
                                        board.square_at(row, col).nil?
    end
    attacking_moves.each { |move| @possible_moves << move }
  end

  def remove_double_moves
    @moves.delete_if { |move| (move[0].abs > 1) && moves_made.positive? }
  end

  def attacking_moves(removing_king_checks = false)
    pawn_attack_moves = [[-1, 1], [-1, -1]] if color == :white
    pawn_attack_moves = [[1, 1], [1, -1]] if color == :black
    moves = []

    pawn_attack_moves.each do |move|
      row = position.row + move[0]
      col = position.col + move[1]
      moves << [row, col] if row.between?(0, 7) &&
                              col.between?(0, 7) &&
                              opponent?(removing_king_checks, row, col)
    end
    moves
  end

  def attacking_moves_only
    @possible_moves.clear
    attacking_moves(true)
  end

  def opponent?(removing_king_checks = false, row, col)
    return true if removing_king_checks

    board.opponent?(row, col, color)
  end

  def can_be_promoted?
    (position.row == 0 && color == :white) ||
    (position.row == 7 && color == :black)
  end

  def symbol
    if color == :white
      "♟"
    elsif color == :black
      "\u001b[30m\u265F"
    end
  end
end
