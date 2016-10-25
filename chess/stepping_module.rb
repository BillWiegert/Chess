module SteppingPiece

  def moves
    move_dirs.map do |step|
      step[0] += @position[0]
      step[1] += @position[1]
      step
    end
  end
end
