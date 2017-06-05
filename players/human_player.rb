require_relative 'player'

class HumanPlayer < Player

  def make_move(board)
    start_pos, end_pos = nil, nil

    until start_pos && end_pos
      system "clear"
      display.show_cursor = true
      display.render

      if start_pos
        puts "#{color}'s turn. Move to where?"
        end_pos = display.cursor.get_input

        if end_pos
          display.reset!
          display.selected = nil
        end
      else
        puts "#{color}'s turn. Move from where?"
        start_pos = display.cursor.get_input

        if start_pos
          display.reset!
          display.selected = start_pos
        end
      end
    end

    [start_pos, end_pos]
  end

  def promote_to
    puts "Choose a piece to promote to: (Q R B N)"
    choice = gets.chomp.downcase
    case choice
    when "q"
      return Queen
    when "r"
      return Rook
    when "b"
      return Bishop
    when "n"
      return Knight
    else
      system "clear"
      display.render
      puts "Invalid choice"
      return promote_to
    end
  end
end
