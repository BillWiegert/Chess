require_relative "pieces"
require_relative "move"
require 'byebug'

class Board

  RANKS = {
    0 => "8",
    1 => "7",
    2 => "6",
    3 => "5",
    4 => "4",
    5 => "3",
    6 => "2",
    7 => "1"
  }

  FILES = {
    0 => "a",
    1 => "b",
    2 => "c",
    3 => "d",
    4 => "e",
    5 => "f",
    6 => "g",
    7 => "h"
  }

  REV_RANKS = RANKS.invert
  REV_FILES = FILES.invert

  attr_accessor :grid, :pending_promotion, :move_history, :ghost_pawns

  def initialize(fill = true)
    @pending_promotion = false
    @ghost_pawns = {
      white: nil,
      black: nil
    }
    @move_history = []
    make_starting_grid(fill)
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def inspect
    "Board: =>"
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def pos_to_s(pos)
    # [3, 1] => 'b3'
    raise "Invalid position" unless pos.class == Array && pos.length == 2
    FILES[pos[1]] + RANKS[pos[0]]
  end

  def str_to_pos(str)
    # 'b3' => [3, 1]
    raise "String does not represent a valid position" unless str.length == 2
    [REV_RANKS[str[1]], REV_FILES[str[0]]]
  end

  def pieces
    @grid.flatten.reject { |piece| piece.empty? }
  end

  def empty?(pos)
    self[pos].empty? || self[pos].class == GhostPawn
  end

  def dup
    new_board = Board.new(false)
    pieces.each do |piece|
      new_piece = piece.dup(new_board)
      new_board[piece.pos] = new_piece
    end

    new_board
  end

  def move_piece(turn_color, from_pos, to_pos)
    raise "There is no piece there!" if empty?(from_pos)

    piece = self[from_pos]

    if piece.color != turn_color
      raise "That is not your piece"
    elsif !piece.moves.include?(to_pos)
      raise "Invalid move: #{self[from_pos]}, #{from_pos}, #{to_pos}"
    elsif !piece.valid_moves.include?(to_pos)
      raise 'You cannot move into check'
    end

    if self[to_pos].class == GhostPawn && piece.class == Pawn
      capture_ghost(to_pos)
    end

    self.move_piece!(from_pos, to_pos)

    if piece.class == Rook || piece.class == King
      piece.can_castle = false if piece.can_castle
    end

    # If King moved two spaces move Rook to complete castle
    if piece.class == King && (from_pos[1] - to_pos[1]) % 2 == 0 &&
      from_pos[0] == to_pos[0]
      if from_pos[1] - to_pos[1] == 2
        # Left Rook
        rook_pos = [from_pos[0], 0]
        dest_pos = [from_pos[0], 3]
      else
        # Right Rook
        rook_pos = [from_pos[0], 7]
        dest_pos = [from_pos[0], 5]
      end
      move_piece!(rook_pos, dest_pos, false)
    end

    if piece.class == Pawn
      if piece.promotion_row == to_pos[0]
        @pending_promotion = true
      else
        move_dist = to_pos[0] - from_pos[0]

        if move_dist == -2 || move_dist == 2
          ghost_pos = [to_pos[0] - move_dist * 0.5, to_pos[1]]
          ghost = GhostPawn.new(piece.color, self, ghost_pos)
          ghost.origin = piece.pos
          self[ghost_pos] = ghost
          @ghost_pawns[ghost.color] = ghost_pos
        end
      end
    end
  end

  def move_piece!(from_pos, to_pos, record = true)
    moved_piece, dest_piece = self[from_pos], self[to_pos]

    if record
      move = Move.new(from_pos, to_pos, self)
      move_history << move
    end

    self[to_pos] = self[from_pos]
    self[from_pos] = NullPiece.new(:nil, self, from_pos)
    self[to_pos].pos = to_pos
  end

  def undo
    move = move_history.pop
    self[move.from] = move.moved_piece
    self[move.from].pos = move.from
    self[move.to] = move.dest_piece
  end

  def promote_pawn(piece_type, pos)
    color = self[pos].color
    self[pos] = piece_type.new(color, self, pos)
    move_history.last.promote_to(piece_type)
    @pending_promotion = false
  end

  def exterminate_ghosts(color)
    if @ghost_pawns[color]
      pos = @ghost_pawns[color]
      if self[pos].class == GhostPawn
        self[pos] = NullPiece.new(:nil, self, pos)
      end
      @ghost_pawns[color] = nil
    end
  end

  def capture_ghost(pos)
    raise "That is not a ghost pawn" unless self[pos].class == GhostPawn
    origin_pos = self[pos].origin
    self[origin_pos] = NullPiece.new(:nil, self, origin_pos)
  end

  def in_check?(color)
    king_pos = find_king(color).pos
    pieces.any? do |p|
      p.color != color && p.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    get_pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def stalemate?(color)
    my_pieces = get_pieces(color)
    return true if my_pieces.all? { |p| p.valid_moves.empty? }

    enemy_pieces = get_pieces(opp_color(color))

    if my_pieces.length == 1
      # King vs King
      if enemy_pieces.length == 1
        return true
      end

      # King vs King and (Bishop or Knight)
      if enemy_pieces.length == 2
        return true if enemy_pieces.any? do |piece|
          piece.class == Bishop || piece.class == Knight
        end
      end
    end

    # If all pieces are either Kings or Bishops
    if pieces.all? { |p| p.class == King || p.class == Bishop }
      bishops = pieces.select { |p| p.class == Bishop }
      first_square_color = bishops.first.square_color

      # If all bishops are on the same color square
      if bishops[1..-1].all? { |b| b.square_color == first_square_color }
        return true
      end
    end

    false
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def update_positions
    @grid.each_with_index do |row, y_index|
      row.each_with_index do |piece, x_index|
        piece.pos = [y_index, x_index]
      end
    end
  end

  private

  def get_pieces(color)
    pieces.select { |p| p.color == color }
  end

  def opp_color(color)
    color == :white ? :black : :white
  end

  def find_king(color)
    king_pos = pieces.find { |p| p.color == color && p.is_a?(King) }
    king_pos || (raise 'king not found?')
  end

  def make_starting_grid(fill)
    @grid = Array.new(8) { Array.new(8) }

    @grid[0..7].map! do |row|
      row.map! { |cell| cell = NullPiece.new(:nil, self) }
    end

    if fill
      @grid[0] = kings_row(:black)
      @grid[1] = pawn_row(:black)
      @grid[6] = pawn_row(:white)
      @grid[7] = kings_row(:white)
    end

    update_positions
  end

  def kings_row(color)
    [ Rook.new(color, self),
      Knight.new(color, self),
      Bishop.new(color, self),
      Queen.new(color, self),
      King.new(color, self),
      Bishop.new(color, self),
      Knight.new(color, self),
      Rook.new(color, self)
    ]
  end

  def pawn_row(color)
    Array.new(8) { Pawn.new(color, self) }
  end
end
