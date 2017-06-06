require_relative 'piece'
require_relative 'sliding_module'

class Bishop < Piece
  include SlidingPiece
  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♝")
    super(color, board, pos)
  end

  def initial
    "B"
  end

  def move_dirs
    diagonal
  end

  def square_color
    raise "Bishop has no position" unless pos
    pos[0] + pos[1] % 2 == 0 ? :white : :black
  end
end
