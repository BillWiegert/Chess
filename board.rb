require_relative "pieces.rb"

class Board

  attr_reader :grid

  def initialize(fill = true)
    if fill
      make_starting_grid
    end
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

  def pieces
    @grid.flatten.reject { |piece| piece.empty? }
  end

  def empty?(pos)
    self[pos].empty?
  end

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, new_board, piece.pos)
    end

    new_board
  end

  def move_piece(turn_color, from_pos, to_pos)
    raise "There is no piece there!" if empty?(from_pos)

    piece = self[from_pos]
    if piece.color != turn_color
      raise "You must move your own pieces"
    elsif !piece.moves.include?(to_pos)
      raise 'Piece does not move like that'
    elsif !piece.valid_moves.include?(to_pos)
      raise 'You cannot move into check'
    end

    self.move_piece!(from_pos, to_pos)
  end

  def move_piece!(from_pos, to_pos)
    self[to_pos] = self[from_pos]
    self[from_pos] = NullPiece.new(:nil, self)
    self.update_positions
  end

  def in_check?(color)
    king_pos = find_king(color).pos
    pieces.any? do |p|
      p.color != color && p.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces.select { |p| p.color == color }.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def update_positions
    @grid.each_with_index do |row, y_index|
      row.each_with_index do |piece, x_index|
        piece.get_pos([y_index, x_index])
      end
    end
  end

  protected

  def find_king(color)
    king_pos = pieces.find { |p| p.color == color && p.is_a?(King) }
    king_pos || (raise 'king not found?')
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
