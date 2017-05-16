require_relative 'piece'
require_relative 'sliding_module'

class Queen < Piece
  include SlidingPiece
  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♛")
    super(color, board)
  end

  def move_dirs
    perpendicular + diagonal
  end

end
