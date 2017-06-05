require_relative 'player'

class ComputerPlayer < Player

  VALUES = {
    "Pawn" => 1,
    "GhostPawn" => 1,
    "Knight" => 3,
    "Bishop" => 3,
    "Rook" => 5,
    "Queen" => 9,
    "King" => 10
  }

  MIN_MOVE_TIME = 0.5 # minimum computing time for one move

  attr_reader :board

  def make_move(board)
    start_time = Time.now.to_i
    @board = board
    system "clear"
    display.show_cursor = false
    display.render

    capturable = capturable_pieces
    threatened = threatened_pieces.reject do |p|
      p.valid_moves.length == 0
    end

    if capturable.length > 0
      most_valuable = capturable.first

      capturable[1..-1].each do |piece|
        if piece_value(piece) > piece_value(most_valuable)
          most_valuable = piece
        end
      end

      attackers = movable_pieces.select do |piece|
        piece.valid_moves.any? { |move| move == most_valuable.pos }
      end

      attacker = attackers.first

      attackers[1..-1].each do |piece|
        if piece_value(piece) < piece_value(attacker)
          attacker = piece
        end
      end

      start_pos, end_pos = attacker.pos, most_valuable.pos
    elsif threatened.length > 0
      most_valuable = threatened.first

      threatened[1..-1].each do |piece|
        if piece_value(piece) > piece_value(most_valuable)
          most_valuable = piece
        end
      end

      start_pos = most_valuable.pos
      possible_moves = most_valuable.valid_moves
      end_pos = possible_moves[rand(possible_moves.length)]
    else
      piece_to_move = movable_pieces[rand(movable_pieces.length)]
      start_pos = piece_to_move.pos

      possible_moves = piece_to_move.valid_moves
      end_pos = possible_moves[rand(possible_moves.length)]
    end

    remaining_time = MIN_MOVE_TIME - (Time.now.to_i - start_time)
    sleep(remaining_time) if remaining_time > 0

    [start_pos, end_pos]
  end

  def promote_to
    Queen
  end

  private

  def my_pieces()
    board.pieces.select { |piece| piece.color == color }
  end

  def movable_pieces()
    my_pieces.select { |piece| piece.valid_moves.length > 0 }
  end

  def enemy_pieces()
    board.pieces.select { |piece| piece.color != color && piece.class != GhostPawn }
  end

  def capturable_pieces()
    enemy_pieces.select do |enemy_piece|
      movable_pieces.any? do |my_piece|
        my_piece.valid_moves.any? do |move|
          move == enemy_piece.pos
        end
      end
    end
  end

  def threatened_pieces()
    my_pieces.select do |my_piece|
      enemy_pieces.any? do |enemy_piece|
        enemy_piece.valid_moves.any? do |move|
          move == my_piece.pos
        end
      end
    end
  end

  def piece_value(piece)
    VALUES[piece.class.to_s]
  end
end
