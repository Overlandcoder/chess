class Coordinate
  attr_reader :row, :col

  def initialize(row:, col:)
    @row, @col = row, col
  end

  def update_row(new_row)
    @row = new_row
  end

  def update_col(new_col)
    @col = new_col
  end
end
