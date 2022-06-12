class Coordinate
  attr_reader :row, :col

  def initialize(row:, col:)
    @row, @col = row, col
  end
end
