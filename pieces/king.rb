require_relative 'piece'
require_relative 'stepping_module'

class King < Piece
  include SteppingPiece
  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♚")
    super(color, board)
  end

  def move_dirs
    [[1,1], [-1,1], [-1,-1], [1,-1],
     [0,1], [1, 0], [0,-1], [-1,0]]
  end
end
