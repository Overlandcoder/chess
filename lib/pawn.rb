class Pawn
  attr_reader :color, :number, :position, :destination, :board, :title,
              :possible_moves, :moves_made, :moved_two_squares

  attr_accessor :capturing_en_passant

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
      @position = Coordinate.new(row: 6, col: start_col)
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
    two_square_move?
    position.update_row(row)
    position.update_col(col)
    @moves_made += 1
  end

  def generate_possible_moves
    @possible_moves.clear
    remove_two_square_moves_if_moves_made
    remove_two_square_moves_if_path_blocked

    @moves.each do |move|
      row = position.row + move[0]
      col = position.col + move[1]
      next unless row.between?(0, 7) && col.between?(0, 7)

      @possible_moves << [row, col] if board.square_at(row, col).nil?
    end
    add_capturing_moves
  end

  def remove_two_square_moves_if_moves_made
    @moves.delete_if { |move| (move[0].abs > 1) && moves_made.positive? }
  end
  
  def remove_two_square_moves_if_path_blocked
    @moves.delete_if do |move|
      first_square_row = position.row - 1 if color == :white
      first_square_row = position.row + 1 if color == :black
      
      !board.square_at(first_square_row, position.col).nil?
    end
  end

  def add_capturing_moves(removing_king_checks = false)
    pawn_capture_moves = [[-1, 1], [-1, -1]] if color == :white
    pawn_capture_moves = [[1, 1], [1, -1]] if color == :black
    moves = []

    pawn_capture_moves.each do |move|
      row = position.row + move[0]
      col = position.col + move[1]
      moves << [row, col] if row.between?(0, 7) &&
                              col.between?(0, 7) &&
                              opponent?(removing_king_checks, row, col)
    end
    moves
  end

  def capturing_moves_only
    @possible_moves.clear
    add_capturing_moves(true)
  end

  def add_en_passant_moves
    left_piece = board.square_at(position.row, position.col - 1)
    right_piece = board.square_at(position.row, position.col + 1)
    next_row = position.row + 1 if color == :black
    next_row = position.row - 1 if color == :white

    if left_piece && left_piece.moved_two_squares
      @possible_moves << [next_row, position.col - 1]
    elsif right_piece && right_piece.moved_two_squares
      @possible_moves << [next_row, position.col + 1]
    end
  end

  def opponent?(removing_king_checks = false, row, col)
    return true if removing_king_checks

    board.opponent?(row, col, color)
  end

  def can_be_promoted?
    (position.row == 0 && color == :white) ||
    (position.row == 7 && color == :black)
  end

  def two_square_move?
    if (position.row - destination.row).abs == 2
      @moved_two_squares = true
    else
      @moved_two_squares = false
    end
  end

  def symbol
    if color == :white
      "♟"
    elsif color == :black
      "\u001b[30m\u265F"
    end
  end
end
