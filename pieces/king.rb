require_relative 'piece'
require_relative 'stepping_module'

class King < Piece
  include SteppingPiece

  attr_accessor :can_castle

  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♚")
    @can_castle = true
    super(color, board, pos)
  end

  def move_dirs
    dirs = [[1,1],[-1,1],[-1,-1],[1,-1],[0,1],[1,0],[0,-1],[-1,0]]
    dirs << [0,-2] if castleable?(:queen)
    dirs << [0, 2] if castleable?(:king)

    dirs
  end

  def castleable?(side)
    return false unless can_castle

    if side == :queen
      rook = board[[pos[0], 0]]
      castle_path = [[pos[0], 2], [pos[0], 3]]
    elsif side == :king
      rook = board[[pos[0], 7]]
      castle_path = [[pos[0], 5], [pos[0], 6]]
    else
      raise "Invalid castle side."
    end

    return false unless rook.class == Rook && rook.can_castle
    return false unless castle_path.all? { |path_pos| board.empty?(path_pos) }
    castle_path << pos
    
    return false if castle_path.any? do |path_pos|
      board.pieces.any? do |p|
        next if p.class == King && p.can_castle
        p.color != color && p.moves.include?(path_pos)
      end
    end

    return true
  end
end
