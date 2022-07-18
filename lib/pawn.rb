class Pawn
  attr_reader :color, :number, :position, :destination, :board, :possible_moves,
              :moves_made, :moved_two_squares

  attr_accessor :capturing_en_passant, :moved_last

  def initialize(color, number, board)
    @color = color
    @number = number
    @board = board
    create_coordinate
    @possible_moves = []
    @moves_made = 0
    @moved_last = false
  end

  def regular_move
    { :white => [-1, 0], :black => [1, 0] }[color]
  end

  def double_move
    { :white => [-2, 0], :black => [2, 0] }[color]
  end

  def to_s
    color == :white ? "\u001b[37;1m\u265F" : "\u001b[30m\u265F"
  end

  def start_row
    { :white => 6, :black => 1 }[color]
  end

  def create_coordinate
    start_col = [0, 1, 2, 3, 4, 5, 6, 7][number]
    @position = Coordinate.new(row: start_row, col: start_col)
  end

  def valid_move?
    @possible_moves.include?([destination.row, destination.col])
  end

  def set_destination(coordinate)
    @destination = coordinate
  end

  def update_position(row = destination.row, col = destination.col)
    two_square_move?
    position.update_row(row)
    position.update_col(col)
    @moves_made += 1
  end

  def generate_possible_moves
    @possible_moves.clear
    add_single_square_move
    add_two_square_move
    capturing_moves.each { |move| @possible_moves << move }
    add_en_passant_moves
  end

  def add_single_square_move
    row = position.row +  regular_move[0]
    col = position.col + regular_move[1]
    @possible_moves << [row, col] if board.square_at(row, col).nil?
  end

  def add_two_square_move
    return unless moves_made.zero?

    row = position.row + regular_move[0]
    col = position.col + regular_move[1]
    return unless board.square_at(row, col).nil?

    row = position.row + double_move[0]
    col = position.col + double_move[1]
    @possible_moves << [row, col] if board.square_at(row, col).nil?
  end

  def capturing_moves(removing_king_checks = false)
    pawn_capture_moves = [[-1, 1], [-1, -1]] if color == :white
    pawn_capture_moves = [[1, 1], [1, -1]] if color == :black
    moves = []

    pawn_capture_moves.each do |move|
      row = position.row + move[0]
      col = position.col + move[1]
      moves << [row, col] if row.between?(0, 7) &&
                              col.between?(0, 7) &&
                              opponent?(row, col, removing_king_checks)
    end
    moves
  end

  def capturing_moves_only
    @possible_moves.clear
    capturing_moves(true)
  end

  def add_en_passant_moves
    next_row = position.row + 1 if color == :black
    next_row = position.row - 1 if color == :white
    left_en_passant_capture(next_row)
    right_en_passant_capture(next_row)
  end

  def left_en_passant_capture(next_row)
    l_piece = board.square_at(position.row, position.col - 1)
    return unless l_piece.is_a?(Pawn)
    return unless l_piece.moved_two_squares && l_piece.moves_made == 1 &&
                  l_piece.moved_last

    next_col = position.col - 1
    @possible_moves << [next_row, next_col] if next_col.between?(0, 7)
  end

  def right_en_passant_capture(next_row)
    r_piece = board.square_at(position.row, position.col + 1)
    return unless r_piece.is_a?(Pawn)
    return unless r_piece.moved_two_squares && r_piece.moves_made == 1 &&
                  r_piece.moved_last

    next_col = position.col + 1
    @possible_moves << [next_row, next_col] if next_col.between?(0, 7)
  end

  def opponent?(row, col, removing_king_checks = false)
    return true if removing_king_checks

    board.opponent?(row, col, color)
  end

  def can_be_promoted?
    (position.row.zero? && color == :white) ||
      (position.row == 7 && color == :black)
  end

  def two_square_move?
    @moved_two_squares = (position.row - destination.row).abs == 2
  end
end
