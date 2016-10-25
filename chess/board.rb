class Board

  attr_reader :grid

  def initialize
    make_starting_grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def inspect
    "Board: =>"
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
  def update_positions
    @grid.each_with_index do |row, y_index|
      row.each_with_index do |piece, x_index|
        piece.get_pos([y_index, x_index])
      end
    end
  end

  protected

  def find_king(color)
  end

  def make_starting_grid
    @grid = Array.new(8) { Array.new(8) }

    @grid[0] = kings_row(:black)
    @grid[1] = pawn_row(:black)
    @grid[6] = pawn_row(:white)
    @grid[7] = kings_row(:white)

    @grid[2..5].map! do |row|
      row.map! { |cell| cell = NullPiece.new(:nil, self) }
    end
    update_positions
  end

  def kings_row(color)
    [ Rook.new(color, self),
      Knight.new(color, self),
      Bishop.new(color, self),
      Queen.new(color, self),
      King.new(color, self),
      Bishop.new(color, self),
      Knight.new(color, self),
      Rook.new(color, self)
    ]
  end

  def pawn_row(color)
    Array.new(8) { Pawn.new(color, self) }
  end
end
