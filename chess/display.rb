
require "colorize"

class Display

  def initialize(board, cursor)
    @board = board
    @grid = board.grid
    @cursor = cursor
  end

  def inspect
    "Display =>"
  end

  def render
    @grid.flatten.each
    count = 0
    line  = 0
    puts " 0  1  2  3  4  5  6  7"
    @grid.each_with_index do |row, x_index|
      row.each_with_index do |cell, y_index|
        if @cursor.cursor_pos == [x_index, y_index]
          print " #{cell.to_s} ".colorize(:background => :red)
        else
          print " #{cell.to_s} ".colorize(:background => checker(count))
        end
        count += 1
      end
      print " #{line}"
      line += 1
      puts ""
      count += 1
    end
  end

  def checker(num)
    if num %2 == 0
      :light_black
    else
      :blue
    end
  end
end
