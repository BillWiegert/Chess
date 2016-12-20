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
      origin = key_press.dup
      @display.selected = origin
      puts "Where would you like to move it?"
      new_position = move_cursor
      @board[new_position] = @board[origin]
      @board[origin] = NullPiece.new(:nil, @board)
      @display.selected = nil
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
cursor = Cursor.new([3,3], board)
display = Display.new(board, cursor)
game = Game.new(display, cursor, board)
game.run
