require 'singleton'
require_relative 'piece'

class NullPiece < Piece
  include Singleton

  def initialize
    @symbol = define_symbol(" ")
    @color = :nil
  end

  def self.initial
    "NULL"
  end
end
