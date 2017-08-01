require_relative 'player'
require 'byebug'

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

  PS_TABLES = {
    "Pawn" => PAWN_PS,
    "Knight" => KNIGHT_PS,
    "Bishop" => BISHOP_PS,
    "Rook" => ROOK_PS,
    "Queen" => QUEEN_PS,
    "King" => KING_PS
  }

  attr_reader :board

  def make_move(board)
    @board = board
    system "clear"
    display.show_cursor = false
    display.render

    return find_best_move
  end

  def promote_to
    Queen
  end

  private

  def opp_color(c = nil)
    if c
      return c == :white ? :black : :white
    end

    color == :white ? :black : :white
  end

  def my_pieces()
    board.pieces.select { |piece| piece.color == color }
  end

  def enemy_pieces()
    board.pieces.select { |piece| piece.color == opp_color}
  end

  def piece_value(piece)
    VALUES[piece.class.to_s]
  end

  # def _find_best_move()
  #   best_score = -99999
  #   best_move = nil
  #
  #   my_pieces().each do |piece|
  #     piece.valid_moves.each do |move|
  #       test_board = board.dup
  #       test_board.move_piece!(piece.pos, move)
  #       new_score = minimax(1, test_board, false)
  #
  #       if new_score > best_score
  #         best_move = [piece.pos, move]
  #         best_score = new_score
  #       end
  #     end
  #   end
  #
  #   best_move
  # end

  def find_best_move()
    @pos_count = 0
    @start_time = Time.now

    best_score = -99999
    best_move = nil

    my_pieces().each do |piece|
      piece.valid_moves.each do |move|
        board.move_piece(color, piece.pos, move)
        new_score = minimax(2, board, false, -100000, 100000)
        board.undo

        if new_score > best_score
          best_move = [piece.pos, move]
          best_score = new_score
        end
      end
    end

    print "#{@pos_count} in #{Time.now - @start_time}s"


    best_move
  end

  def minimax(depth, test_board, my_turn, alpha, beta)
    @pos_count += 1

    if depth == 0
      return evaluate_position(test_board)
    end

    if my_turn
      best_score = -99999

      my_pieces.each do |piece|
        piece.valid_moves.each do |move|
          test_board.move_piece(color, piece.pos, move)

          # test_display = Display.new(test_board)
          # system "clear"
          # test_display.render
          # sleep 0.25

          best_score = [best_score, minimax(depth - 1, test_board, !my_turn, alpha, beta)].max
          test_board.undo

          alpha = [best_score, alpha].max

          return best_score if beta <= alpha
        end
      end

      return best_score

    else # Enemy Turn
      best_score = 99999

      enemy_pieces.each do |piece|
        piece.valid_moves.each do |move|
          test_board.move_piece(opp_color, piece.pos, move)

          # test_display = Display.new(test_board)
          # system "clear"
          # test_display.render
          # sleep 0.25

          best_score = [best_score, minimax(depth-1, test_board, !my_turn, alpha, beta)].min
          test_board.undo

          beta = [best_score, beta].min

          return best_score if beta <= alpha
        end
      end

      return best_score
    end
  end

  def evaluate_position(test_board)
    score = 0
    test_board.pieces.each do |piece|
      score += evaluate_piece(piece)
    end

    score
  end

  def evaluate_piece(piece)
    type = piece.class.to_s
    y,x = piece.pos

    return 0 unless VALUES.keys.include?(type)

    value = piece_value(piece)
    value += PS_TABLES[type][piece.color][y][x]

    piece.color == color ? value : -value
  end
end

# White move, depth, positions, time, notes
# c3, 3, 9712, 483s, no a-b, move_piece! and undo
# c3, 3, 2930, 137s, with a-b, move_piece! and undo, 21.3 pos/s
# c3, 3, 2930, 170s, with a-b, move_piece and undo, 17.2 pos/s
# c3, 2, 440, 24.8s, with a-b, move_piece & undo, 17.7 pos/s
# c3, 2, 440, 12s, with a-b, move_piece & undo, no display, 36 pos/s
