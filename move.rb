require_relative "board"

TYPES = [:symbolic, :PGN]

class Move

  attr_reader :from, :to, :board, :moved_piece,
    :dest_piece, :color, :opp_color, :notation

  def initialize(from, to, moved_piece, dest_piece, board)
    @from, @to, @board = from, to, board
    @moved_piece, @dest_piece = moved_piece, dest_piece
    @color = moved_piece.color
    @opp_color = color == :white ? :black : :white
    @notation = generate_notation(:PGN)
  end

  def inspect
    "Move => #{notation}"
  end

  private

  def generate_notation(type)
    raise "Invalid notation type" unless TYPES.include?(type)
    str = ""

    if castle?
      str << castle?
    elsif moved_piece.class == Pawn
      str << board.pos_to_s(from)[0] if capture?
    elsif type == :symbolic
      str << moved_piece.symbol + " "
    elsif type == :PGN
      str << moved_piece.initial
    end

    unless castle?
      str << "x" if capture?
      str << board.pos_to_s(to)
    end

    if board.checkmate?(opp_color)
      str << "#"
    elsif board.in_check?(opp_color)
      str << "+"
    end

    str
  end

  def capture?
    return true unless dest_piece.class == NullPiece
    if dest_piece.class == GhostPawn && moved_piece.class == Pawn
      return true
    end

    false
  end

  def castle?
    return false unless moved_piece.class == King
    return "O-O-O" if from[1] - to[1] == 2 # Queen side castle
    return "O-O" if from[1] - to[1] == -2 # King side castle
    return false
  end
end
