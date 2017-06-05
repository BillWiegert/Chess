require_relative "board"
require 'byebug'

class Move

  attr_reader :from, :to, :board

  def initialize(from, to, board)
    @from, @to, @board = from, to, board
  end

  def inspect
    "Move =>"
  end

  def notation
    piece = board[from]
    str = ""
    piece.class == Pawn ? str << board.pos_to_s(from)[0] :
      str << piece.symbol + " "

    # check if any piece of the same class and color can make the same move

    str << "x" if capture?
    str << board.pos_to_s(to)

    str
  end

  def capture?
    return true unless board.empty?(to)
    if board[to].class == GhostPawn && board[from].class == Pawn
      return true if board[to].color != board[from].color
    end

    false
  end
end
