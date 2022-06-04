class Rook
  attr_reader :color, :number, :position, :destination

  def initialize(color, number)
    @color = color
    @number = number
    @position = [[7, 0], [7, 7]][number] if color == 'white'
    @position = [[0, 0 ], [0, 7]][number] if color == 'black'
  end

  def symbol
    if color == 'white'
      "\u001b[37;1m\u265C"
    elsif color == 'black'
      "\u001b[30m\u265C"
    end
  end

  def change_position(destination)
    @destination = destination

    if valid_move?
      
    end
  end

  def valid_move?
    within_board? && path_empty? && (vertical_move? || horizontal_move?)
  end

  def path_empty?
    if vertical_move?
      start_row = position[0]
      end_row = destination[0]
      column = position[1]

      (start_row..end_row).all? do |row|
        grid[row][column] == "\u001b[47m   \u001b[0m" || grid[row][column] == "\u001b[42m   \u001b[0m"
      end
    elsif horizontal_move?

    end
  end

  def within_board?
    destination[0].between?(0, 7) && destination[1].between?(0, 7)
  end

  def vertical_move?
    destination[0] != position[0] && destination[1] == position[1]
  end

  def horizontal_move?
    destination[0] == position[0] && destination[1] != position[1]
  end
end
