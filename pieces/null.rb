require_relative 'piece'

class NullPiece < Piece
  def initialize(color, board, pos = nil)
    super(color, board, pos)
    @symbol = define_symbol(" ")
  end
end
