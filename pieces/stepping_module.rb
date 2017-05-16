module SteppingPiece

  def moves
    move_dirs.map do |step|
      step[0] += @pos[0]
      step[1] += @pos[1]
      step
    end
  end
end
