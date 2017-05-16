require_relative 'piece'
require_relative 'stepping_module'

class Pawn < Piece
  include SteppingPiece
  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♟")
    super(color, board)
  end

  def move_dirs
    dirs = []
    if @color == :white
      dirs << [-1, 0]
      if @pos[0] == 6
        dirs << [-2, 0]
      end
    else
      dirs << [1, 0]
      if @pos[0] == 1
        dirs << [2,0]
      end
    end

    return dirs
   end
end
