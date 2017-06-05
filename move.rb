require_relative "board"
require 'byebug'

class Move

  attr_reader :from, :to, :board

  def initialize(from, to, board)
    @from, @to, @board = from, to, board
  end

  def inspect
    "Move => #{notation}"
  end

  def notation
    piece = board[from]
    str = ""

    if piece.class == Pawn
      str << board.pos_to_s(from)[0]
    else
      str << piece.symbol + " "
    end

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
