require_relative "board.rb"
require_relative "piece.rb"
require_relative "display.rb"
require "byebug"
require_relative "cursor.rb"

class Game

  def initialize(display, cursor, board)
    @display = display
    @cursor = cursor
    @board = board
  end

  def play
  end

  def run
    while true
      system "clear"
      @display.render
      key_press = move_cursor
      respond_to_input(key_press)
    end
  end

  private

  def notify_players
  end

  def swap_turn!
  end

  def respond_to_input(key_press)
    unless key_press.nil?
      puts "Where would you like to move it?"
      debugger
      new_position = move_cursor

      @board[new_position] = @board[key_press]
      @board[key_press] = NullPiece.new(:nil, @board)
      @board.update_positions
    end
  end

  def move_cursor
    input = @cursor.get_input
    print input
    return input unless input.nil?
    system "clear"
    @display.render
    move_cursor
  end

end





board = board = Board.new
cursor = Cursor.new([4,4], board)
display = Display.new(board, cursor)
game = Game.new(display, cursor, board)
game.run
# bobby = Rook.new(:black, board)
# ronny = Bishop.new(:white, board)
# board[[3,3]] = bobby
# board[[5,7]] = ronny
# board.update_positions
# display.render
# # run(display, cursor)
# puts "bobby rook"
# p bobby.position
# p bobby.moves
# puts "ronny bishop"
# p ronny.position
# p ronny.moves
