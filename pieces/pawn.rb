require_relative 'piece'

class Pawn < Piece

  def initialize(color, board, pos = nil)
    @symbol = define_symbol("♟")
    super(color, board, pos)
  end

  def moves
    forward_moves + diagonal_attacks
  end

  private

  def forward_dir
    (color == :white) ? -1 : 1
  end

  def at_start_row?
    (color == :white) ? (pos[0] == 6) : (pos[0] == 1)
  end

  def forward_moves
    x, y = pos
    one_step = [x + forward_dir, y]

    return [] unless board.valid_pos?(one_step) && board.empty?(one_step)

    valid_moves = [one_step]

    if at_start_row?
      two_step = [x + (forward_dir * 2), y]
      valid_moves << two_step if board.empty?(two_step)
    end

    valid_moves
  end

  def diagonal_attacks
    x, y = pos

    diagonal_moves = [[x + forward_dir, y - 1], [x + forward_dir, y + 1]]

    diagonal_moves.select do |end_pos|
      board.valid_pos?(end_pos) && !board.empty?(end_pos) &&
      board[end_pos].color != color
    end
  end
end
