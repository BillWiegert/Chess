require "colorize"
require_relative "cursor"

class Display

  attr_reader :cursor, :board
  attr_accessor :notifications, :show_cursor, :selected, :last_move

  def initialize(board)
    @board = board
    @cursor = Cursor.new(board)
    @notifications = {}
    @show_cursor = true
  end

  def inspect
    "Display =>"
  end

  def render
    board.grid.flatten.each
    count = 0
    line  = 8

    puts " A  B  C  D  E  F  G  H"
    board.grid.each_with_index do |row, x_index|
      row.each_with_index do |cell, y_index|
        if show_cursor && cursor.cursor_pos == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :red)
        elsif selected && selected == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :green)
        elsif last_move && last_move.from == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :yellow)
        elsif last_move && last_move.to == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :yellow)
        else
          print " #{cell.to_s} ".colorize(background: checker(count))
        end
        count += 1
      end
      print " #{line}"
      line -= 1
      puts ""
      count += 1
    end

    if last_move
      puts last_move.notation
      # piece = board[last_move[1]]
      # str = board.pos_to_s(last_move[1])
      # puts(piece.symbol + " " + str)
    end

    notifications.each do |key, val|
      puts "#{val}"
    end
  end

  def checker(num)
    if num %2 == 0
      :light_black
    else
      :blue
    end
  end

  def reset!
    notifications.delete(:error)
  end

  def uncheck!
    notifications.delete(:check)
  end

  def set_check!
    notifications[:check] = "Check!"
  end
end
