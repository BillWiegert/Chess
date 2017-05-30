require_relative 'piece'

# This is a dummy piece to assist in En Passant logic
class GhostPawn < Piece

  attr_reader :origin

  def initialize(color, board, pos)
    @symbol = define_symbol(" ")
    @origin = origin
    super(color, board, pos)
  end

  def origin=(pos)
    @origin = pos
  end

  def moves
    []
  end

  def dup
    duped = GhostPawn.new(self.color, self.board, self.pos)
    duped.origin = self.origin || nil

    duped
  end
end
