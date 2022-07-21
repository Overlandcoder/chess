class Fen
  def from_fen(fen)
    rows = fen.split('/')
    rows.each_with_index do |row, row_number|
      row.chars.each_with_index do |char, col_number|
        add_rook(row_number, char) if char.capitalize == 'R'
        # add_bishop ...
      end
    end
  end

  row.chars.reduce([]) do |arr, char|
    if char.to_i == 0
      arr << char
    else
      arr + [nil] * char.to_i
    end
  end

  def add_rook(row_number, char)
    # add black rook if element == 'r'
    # add white rook if element == 'R'
  end
end