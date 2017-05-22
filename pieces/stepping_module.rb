module SteppingPiece

  def moves
    moves = []

    move_dirs.each do |step|
      step[0] += pos[0]
      step[1] += pos[1]
      moves << step if board.valid_pos?(step) &&
      (board.empty?(step) || board[step].color != color)
    end

    moves
  end
end
