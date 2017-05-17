require_relative "board.rb"
require_relative "pieces.rb"
require_relative "display.rb"
require "byebug"
require_relative "cursor.rb"
require_relative "human_player.rb"

class Game

  attr_reader :board, :display, :players, :current_player

  def initialize(display, cursor, board)
    @display = display
    @cursor = cursor
    @board = board
    @players = {
      white: HumanPlayer.new(:white, @display),
      black: HumanPlayer.new(:black, @display)
    }
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player)
      begin
        start_pos, end_pos = players[current_player].make_move(board)
        board.move_piece(current_player, start_pos, end_pos)

        swap_turn!
        notify_players
      rescue StandardError => e
        display.notifications[:error] = e.message
        retry
      end
    end

    system "clear"
    display.render
    puts "#{current_player} is checkmated."

    nil
  end

  private

  def notify_players
    if board.in_check?(current_player)
      display.set_check!
    else
      display.uncheck!
    end
  end

  def swap_turn!
    current_player == :white ? @current_player = :black : @current_player = :white
  end

  def respond_to_input(key_press)
    unless key_press.nil?
      origin = key_press.dup
      display.selected = origin
      puts "Where would you like to move it?"
      new_position = move_cursor
      display.selected = nil
      @board.move_piece(current_player, origin, new_position)
      swap_turn!
    end
  end

  def move_cursor
    input = @cursor.get_input
    print input
    return input unless input.nil?
    system "clear"
    display.render
    puts "#{current_player.to_s}'s move."
    move_cursor
  end

end

board = board = Board.new
cursor = Cursor.new([3,3], board)
display = Display.new(board, cursor)
game = Game.new(display, cursor, board)
game.play
