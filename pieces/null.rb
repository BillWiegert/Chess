require_relative 'piece'

class NullPiece < Piece
  def initialize(color, board)
    super(color, board)
    @symbol = define_symbol(" ")
  end
end
