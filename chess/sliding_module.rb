module SlidingPiece

DIAGS = [
  [ 1, 1],
  [ 1,-1],
  [-1, 1],
  [-1,-1]
]

  def moves
    case move_dirs
    when :perpendicular
      move_perpendicular
    when :diagonal
      move_diag
    when :omni
      move_diag + move_perpendicular
    end
  end

  def move_perpendicular
    move_list = []

    # debugger

    2.times do |i|
      (@position[0] + 1).upto(7) do |num|
        # debugger
        i == 0 ? (pos = @position.first, num) : (pos = num, @position.last)
        break unless check_path(move_list, pos)
      end

      # 0.upto(@position[1] - 1) do |num|
      (@position[1] - 1).downto(0) do |num|
        i == 0 ? (pos = @position.first, num) : (pos = num, @position.last)
        break unless check_path(move_list, pos)
      end
    end

    move_list
  end

  def in_bounds?(pos)
    pos.all? { |num| num.between?(0,7) }
  end

  def check_path(move_list, pos)
    if !in_bounds?(pos) || @board[pos].color == @color
      false
    elsif @board[pos].color == :nil
      move_list << pos
      true
    else
      move_list << pos
      false
    end
  end

  def move_diag
    diagonal = []
    DIAGS.each do |delta|
      1.upto(7) do |num|
        pos = [@position[0] + delta[0] * num, @position[1] + delta[1] * num]
        break unless check_path(diagonal, pos)
      end
    end

    diagonal
  end

end
