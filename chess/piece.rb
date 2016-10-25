require 'colorize'
require_relative 'stepping_module.rb'
require_relative 'sliding_module.rb'
require "byebug"

class Piece

  attr_reader :symbol, :position, :color

  def initialize(color, board)
    check_color(color)
    @color = color
    @board = board
  end

  def inspect
    "Piece => #{@color}, => #{@symbol}"
  end

  def get_pos(pos)
    @position = pos
  end

  def to_s
    @symbol.colorize(@color)
  end

  def empty?
    @color == :nil
  end

  def symbol
    @symbol
  end


  def valid_moves
    moves.select do |move|
      move.all? { |coordinate| coordinate.between?(0,7) } &&
      (board[move].empty? || board[move].color != self.color)
    end
  end

  private

  def move_into_check(to_pos)
  end

  def define_symbol(sym)
    if @color == :nil
      @symbol = sym
    else
      @symbol = sym.colorize(@color)
    end
  end

  def check_color(color)
    unless color == :white || color == :black || :nil
    raise ArgumentError "Color must be passed as :nil, :black, or :white."
  end
  end
end

## Swapping peice
class NullPiece < Piece
  def initialize(color, board)
    super(color, board)
    @symbol = define_symbol(" ")
  end
end

### SLIDING PIECES
class Rook < Piece
  include SlidingPiece
  def initialize(color = :nil, board)
    @symbol = define_symbol("♜")
    super(color, board)
  end

  def move_dirs
    :perpendicular
  end
end

class Bishop < Piece
  include SlidingPiece
  def initialize(color, board)
    @symbol = define_symbol("♝")
    super(color, board)
  end

  def move_dirs
    :diagonal
  end
end

class Queen < Piece
  include SlidingPiece
  def initialize(color, board)
    @symbol = define_symbol("♛")
    super(color, board)
  end

  def move_dirs
    :omni
  end

end

## STEPPING PIECES
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

class King < Piece
  include SteppingPiece
  def initialize(color, board)
    @symbol = define_symbol("♚")
    super(color, board)
  end

  def move_dirs
    [[1,1], [-1,1], [-1,-1], [1,-1],
     [0,1], [1, 0], [0,-1], [-1,0]]
  end
end

class Pawn < Piece
  def initialize(color, board)
    @symbol = define_symbol("♟")
    super(color, board)
  end
end
