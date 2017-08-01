require_relative "board"
require_relative "display"
require_relative "players"

class Game

  attr_reader :board, :display, :players, :current_player

  def initialize(player1, player2, board = Board.new)
    @board = board
    @display = Display.new(@board)
    @players = {
      white: player1 == :human ? HumanPlayer.new(:white, @display) : SmartAI.new(:white, @display),
      black: player2 == :human ? HumanPlayer.new(:black, @display) : SmartAI.new(:black, @display)
    }
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player) || board.stalemate?(current_player)
      begin
        start_pos, end_pos = players[current_player].make_move(board)
        board.move_piece(current_player, start_pos, end_pos)
        display.last_move = board.move_history.last

        if board.pending_promotion
          piece = players[current_player].promote_to
          board.promote_pawn(piece, end_pos)
        end

        swap_turn!
        notify_players
      rescue StandardError => e
        display.notifications[:error] = e.message
        retry
      end
    end

    system "clear"
    display.render

    if board.checkmate?(current_player)
      puts "Game Over! #{current_player.capitalize} is checkmated."
    else
      puts "Draw! Game ended in stalemate."
    end

    move_num = 1
    board.move_history.each do |m|
      if m.color == :white
        print "#{move_num}. #{m.notation} "
      else
        print "#{m.notation}\n"
        move_num += 1
      end
    end

    print "\n"

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
