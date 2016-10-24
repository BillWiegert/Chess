
require "colorize"

class Display

  def initialize(board, cursor)
    @board = board
    @grid = board.grid
    @cursor = cursor
  end

  def render
    @grid.each_with_index do |row, x_index|
      row.each_with_index do |cell, y_index|
        # debugger
        if @cursor.cursor_pos == [x_index, y_index]
          print "|" + "#".colorize(:red)
        elsif cell.is_a? Piece
          print "|#{cell.to_s}"
        else
          print "| "
        end
      end
      puts "|"
    end
  end
end
