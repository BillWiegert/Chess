class Board

  attr_reader :grid

  def initialize
    make_starting_grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def dup
  end

  def move_piece(from_pos, to_pos)
    raise InvalidMove if self[from_pos].nil?
    positions = from_pos.concat(to_pos).flatten
    unless positions.all? { |i| i.between?(0,7) }
      raise InvalidMove.new "Out of bounds"
    end

    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
  end

  def move_piece!(from_pos, to_pos)
  end

  # def checkmate?
  # end

  protected

  def find_king(color)
  end

  def make_starting_grid
    @grid = Array.new(8) { Array.new(8) }
    grid.map! do |row|
      row.map! { |cell| cell = Piece.new("p") }
    end

    @grid[2..5].map! do |row|
      row.map! { |cell| cell = nil }
    end
  end
end
