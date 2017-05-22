require "colorize"
require_relative "cursor"

class Display

  attr_reader :notifications, :cursor

  def initialize(board)
    @board = board
    @grid = board.grid
    @cursor = Cursor.new(board)
    @notifications = {}
    @selected = nil
    @last_move = nil
  end

  def inspect
    "Display =>"
  end

  def selected=(selected = nil)
    @selected = selected
  end

  def last_move=(last_move = nil)
    @last_move = last_move
  end

  def render
    @grid.flatten.each
    count = 0
    line  = 0
    puts " A  B  C  D  E  F  G  H"
    @grid.each_with_index do |row, x_index|
      row.each_with_index do |cell, y_index|
        if @cursor.cursor_pos == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :red)
        elsif @selected == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :green)
        elsif @last_move == [x_index, y_index]
          print " #{cell.to_s} ".colorize(background: :yellow)
        else
          print " #{cell.to_s} ".colorize(background: checker(count))
        end
        count += 1
      end
      print " #{line}"
      line += 1
      puts ""
      count += 1
    end

    @notifications.each do |key, val|
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
    @notifications.delete(:error)
  end

  def uncheck!
    @notifications.delete(:check)
  end

  def set_check!
    @notifications[:check] = "Check!"
  end
end
