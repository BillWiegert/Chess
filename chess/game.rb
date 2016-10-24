require_relative "board.rb"
require_relative "piece.rb"
require_relative "display.rb"
require "byebug"
require_relative "cursor.rb"

class Game

  def play
  end

  private

  def notify_players
  end

  def swap_turn!
  end
end

def run(display, cursor)
  while true
    display.render
    cursor.get_input
    system "clear"
  end
end

board = Board.new
cursor = Cursor.new([4,4], board)
display = Display.new(board, cursor)
run(display, cursor)
