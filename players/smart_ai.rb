require_relative 'player'

class SmartAI < Player
  VALUES = {
    "Pawn" => 100,
    "Knight" => 320,
    "Bishop" => 330,
    "Rook" => 500,
    "Queen" => 900,
    "King" => 20000
  }

  # Piece-square tables

  WHITE_PAWN_PS = [
    [ 0,  0,  0,  0,  0,  0,  0,  0],
    [50, 50, 50, 50, 50, 50, 50, 50],
    [10, 10, 20, 30, 30, 20, 10, 10],
    [ 5,  5, 10, 25, 25, 10,  5,  5],
    [ 0,  0,  0, 20, 20,  0,  0,  0],
    [ 5, -5,-10,  0,  0,-10, -5,  5],
    [ 5, 10, 10,-20,-20, 10, 10,  5],
    [ 0,  0,  0,  0,  0,  0,  0,  0]
  ]

  WHITE_KNIGHT_PS = [
    [-50,-40,-30,-30,-30,-30,-40,-50],
    [-40,-20,  0,  0,  0,  0,-20,-40],
    [-30,  0, 10, 15, 15, 10,  0,-30],
    [-30,  5, 15, 20, 20, 15,  5,-30],
    [-30,  0, 15, 20, 20, 15,  0,-30],
    [-30,  5, 10, 15, 15, 10,  5,-30],
    [-40,-20,  0,  5,  5,  0,-20,-40],
    [-50,-40,-30,-30,-30,-30,-40,-50]
  ]

  WHITE_BISHOP_PS = [
    [-20,-10,-10,-10,-10,-10,-10,-20],
    [-10,  0,  0,  0,  0,  0,  0,-10],
    [-10,  0,  5, 10, 10,  5,  0,-10],
    [-10,  5,  5, 10, 10,  5,  5,-10],
    [-10,  0, 10, 10, 10, 10,  0,-10],
    [-10, 10, 10, 10, 10, 10, 10,-10],
    [-10,  5,  0,  0,  0,  0,  5,-10],
    [-20,-10,-10,-10,-10,-10,-10,-20]
  ]

  WHITE_ROOK_PS = [
    [ 0,  0,  0,  0,  0,  0,  0,  0],
    [ 5, 10, 10, 10, 10, 10, 10,  5],
    [-5,  0,  0,  0,  0,  0,  0, -5],
    [-5,  0,  0,  0,  0,  0,  0, -5],
    [-5,  0,  0,  0,  0,  0,  0, -5],
    [-5,  0,  0,  0,  0,  0,  0, -5],
    [-5,  0,  0,  0,  0,  0,  0, -5],
    [ 0,  0,  0,  5,  5,  0,  0,  0]
  ]

  WHITE_QUEEN_PS = [
    [-20,-10,-10, -5, -5,-10,-10,-20],
    [-10,  0,  0,  0,  0,  0,  0,-10],
    [-10,  0,  5,  5,  5,  5,  0,-10],
    [ -5,  0,  5,  5,  5,  5,  0, -5],
    [  0,  0,  5,  5,  5,  5,  0,  0],
    [-10,  0,  5,  5,  5,  5,  0,-10],
    [-10,  0,  0,  0,  0,  0,  0,-10],
    [-20,-10,-10, -5, -5,-10,-10,-20]
  ]

  WHITE_KING_PS = [
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-30,-40,-40,-50,-50,-40,-40,-30],
    [-20,-30,-30,-40,-40,-30,-30,-20],
    [-10,-20,-20,-20,-20,-20,-20,-10],
    [ 20, 20,  0,  0,  0,  0, 20, 20],
    [ 20, 30, 10,  0,  0, 10, 30, 20]
  ]

  WHITE_KING_PS_END = [
    [-50,-40,-30,-20,-20,-30,-40,-50],
    [-30,-20,-10,  0,  0,-10,-20,-30],
    [-30,-10, 20, 30, 30, 20,-10,-30],
    [-30,-10, 30, 40, 40, 30,-10,-30],
    [-30,-10, 30, 40, 40, 30,-10,-30],
    [-30,-10, 20, 30, 30, 20,-10,-30],
    [-30,-30,  0,  0,  0,  0,-30,-30],
    [-50,-30,-30,-30,-30,-30,-30,-50]
  ]

  BLACK_PAWN_PS = WHITE_PAWN_PS.reverse
  BLACK_KNIGHT_PS = WHITE_KNIGHT_PS.reverse
  BLACK_BISHOP_PS = WHITE_BISHOP_PS.reverse
  BLACK_ROOK_PS = WHITE_ROOK_PS.reverse
  BLACK_QUEEN_PS = WHITE_QUEEN_PS.reverse
  BLACK_KING_PS = WHITE_KING_PS.reverse
  BLACK_KING_PS_END = WHITE_KING_PS_END.reverse

  PAWN_PS = { white: WHITE_PAWN_PS, black: BLACK_PAWN_PS }
  KNIGHT_PS = { white: WHITE_KNIGHT_PS, black: BLACK_KNIGHT_PS }
  BISHOP_PS = { white: WHITE_BISHOP_PS, black: BLACK_BISHOP_PS }
  ROOK_PS = { white: WHITE_ROOK_PS, black: BLACK_ROOK_PS }
  QUEEN_PS = { white: WHITE_QUEEN_PS, black: BLACK_QUEEN_PS }
  KING_PS = { white: WHITE_KING_PS, black: BLACK_KING_PS }
  KING_PS_END = { white: WHITE_KING_PS_END, black: BLACK_KING_PS_END }

  attr_reader :board

  def make_move(board)
    @board = board
  end

  private

  def my_pieces()
    board.pieces.select { |piece| piece.color == color }
  end

  def piece_value(piece)
    VALUES[piece.class.to_s]
  end

  def find_best_move()
    best_score = -99999

    my_pieces().each do |piece|
      piece.valid_moves.each do |move|
        test_board = board.dup
        test_board.move_piece!(piece.pos, move)
        if evaluate_position(test_board) > best_score
          best_move = [piece.pos, move]
        end
      end
    end

    best_move
  end

  def evaluate_position(test_board)
    score = 0
    test_board.pieces.each do |piece|
      score += evaluate_piece(piece)
    end

    score
  end

  def evaluate_piece(piece)
    value = piece_value(piece)

    # apply piece-square table value modifier

    piece.color == color ? value : -value
  end
end
