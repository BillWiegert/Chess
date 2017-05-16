require_relative 'piece'
require_relative 'stepping_module'

class Knight < Piece
  include SteppingPiece
  def initialize(color, board)
    @symbol = define_symbol("♞")
    super(color, board)
  end

  def move_dirs
    [[-1, -2], [-1, 2], [1, -2], [1, 2],
     [-2, -1], [-2, 1], [2, -1], [2, 1]]
  end
end
