require 'colorize'
require_relative 'stepping_module'
require_relative 'sliding_module'
require "byebug"

class Piece

  attr_reader :symbol, :pos, :color, :board

  def initialize(color, board, pos = nil)
    check_color(color)
    @color = color
    @board = board
    @pos = pos
  end

  def inspect
    "Piece => #{@color}, => #{@symbol}"
  end

  def get_pos(pos)
    @pos = pos
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
    valid = moves.select do |move|
      move.all? { |coordinate| coordinate.between?(0,7) } &&
      (@board[move].empty? || @board[move].color != self.color)
    end
    
    valid.reject { |pos| move_into_check?(pos) }
  end

  private

  def move_into_check?(to_pos)
    test_board = board.dup
    test_board.move_piece!(pos, to_pos)
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
    unless color == :white || color == :black || :nil
    raise ArgumentError "Color must be passed as :nil, :black, or :white."
  end
  end
end
