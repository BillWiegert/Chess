require_relative 'display.rb'
require_relative 'player.rb'

class HumanPlayer < Player

  def make_move(board)
    start_pos, end_pos = nil, nil

    until start_pos && end_pos
      system "clear"
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

end
