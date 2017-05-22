require_relative "board.rb"
require_relative "display.rb"
require_relative "human_player.rb"
require_relative "computer_player.rb"

class Game

  attr_reader :board, :display, :players, :current_player

  def initialize(player1, player2)
    @board = Board.new
    @display = Display.new(@board)
    @players = {
      white: player1 == :human ? HumanPlayer.new(:white, @display) : ComputerPlayer.new(:white, @display),
      black: player2 == :human ? HumanPlayer.new(:black, @display) : ComputerPlayer.new(:black, @display)
    }
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player)
      begin
        start_pos, end_pos = players[current_player].make_move(board)
        board.move_piece(current_player, start_pos, end_pos)
        display.last_move = [start_pos, end_pos]

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
end

if __FILE__ == $PROGRAM_NAME
  puts("White player human? (Y/N)")
  white = gets.chomp.downcase == "y" ? :human : :computer

  puts("Black player human? (Y/N)")
  black = gets.chomp.downcase == "y" ? :human : :computer

  Game.new(white, black).play
end
