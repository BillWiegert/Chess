require_relative 'piece'
require_relative 'sliding_module'

class Rook < Piece
  include SlidingPiece

  attr_accessor :can_castle

  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♜")
    @can_castle = true
    super(color, board, pos)
  end

  def move_dirs
    perpendicular
  end
end
