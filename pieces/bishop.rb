require_relative 'piece'
require_relative 'sliding_module'

class Bishop < Piece
  include SlidingPiece
  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♝")
    super(color, board)
  end

  def move_dirs
    diagonal
  end
end
