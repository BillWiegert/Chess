require 'colorize'
require_relative 'stepping_module'
require_relative 'sliding_module'


class Piece

  attr_reader :symbol, :color, :board
  attr_accessor :pos

  def initialize(color, board, pos = nil)
    check_color(color)
    @color = color
    @board = board
    @pos = pos
  end

  def inspect
    "Piece => #{@color} #{self.class} @ #{@pos}"
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
    moves.reject { |pos| move_into_check?(pos) }
  end

  def dup(new_board)
    self.class.new(self.color, new_board, self.pos)
  end

  private

  def move_into_check?(to_pos)
    test_board = board.dup
    test_board.move_piece!(pos, to_pos, false)
    test_board.in_check?(color)
  end

  def define_symbol(sym)
    if @color == :nil
      @symbol = sym
    else
      @symbol = sym.colorize(@color)
    end
  end

  def check_color(color)
    unless color == :white || color == :black || color == :nil
    raise ArgumentError "Color must be passed as :nil, :black, or :white."
  end
  end
end
