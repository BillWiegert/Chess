class Piece

  attr_reader :name

  def initialize(name = nil)
    @name = name
  end

  def to_s
    return " " if @name == nil
    "♟"
  end

  def empty?
  end

  def symbol
  end

  def valid_moves
  end

  private

  def move_into_check(to_pos)
  end
end
