require_relative "board"
require 'byebug'

TYPES = [:symbolic, :PGN]

class Move

  attr_reader :from, :to, :board, :moved_piece,
    :dest_piece, :color, :opp_color, :notation

  def initialize(from, to, board, type = :PGN)
    @from, @to, @board = from, to, board
    @moved_piece, @dest_piece = board[from], board[to]
    @color = moved_piece.color
    @opp_color = color == :white ? :black : :white
    @notation = generate_notation(type)
  end

  def inspect
    "Move => #{notation}"
  end

  def promote_to(piece_type)
    notation << "=" + piece_type.initial
  end

  def castle?
    return false unless moved_piece.class == King
    return "O-O-O" if from[1] - to[1] == 2 # Queen side castle
    return "O-O" if from[1] - to[1] == -2 # King side castle
    return false
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
      str << moved_piece.class.initial
    end

    str << specificity

    unless castle?
      str << "x" if capture?
      str << board.pos_to_s(to)
    end

    str << check_or_mate?

    str
  end

  def capture?
    return true unless dest_piece.class == NullPiece
    if dest_piece.class == GhostPawn && moved_piece.class == Pawn
      return true
    end

    false
  end

  def check_or_mate?
    test_board = board.dup
    test_board.move_piece!(from, to, false)
    return "#" if test_board.checkmate?(opp_color)
    return "+" if test_board.in_check?(opp_color)

    ""
  end

  def specificity
    similar_pieces = board.pieces.select do |p|
      p.class == moved_piece.class && p.color == color &&
        p.valid_moves.include?(to)
    end

    similar_pieces.reject! { |p| p == moved_piece }

    return "" if similar_pieces.length == 0

    if similar_pieces.none? { |p| p.pos[1] == moved_piece.pos[1] }
      return board.pos_to_s(moved_piece.pos)[0]
    elsif similar_pieces.none? { |p| p.pos[0] == moved_piece.pos[0] }
      return board.pos_to_s(moved_piece.pos)[1]
    else
      return board.pos_to_s(moved_piece.pos)
    end
  end
end
