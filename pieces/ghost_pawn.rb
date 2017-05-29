require_relative 'piece'

# This is a dummy piece to assist in En Passant logic
class GhostPawn < Piece

  attr_reader :origin

  def initialize(color, board, pos, origin)
    @symbol = define_symbol(" ")
    @origin = origin
    super(color, board, pos)
  end

  def moves
    []
  end
end
