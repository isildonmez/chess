# Stores the coordinates of each player
# board[coord] = piece : nil, white_pawn2(instances)
require_relative './pieces'

class Board
  attr_accessor :board

  def initialize()
    @board = {}
    ["a","b","c","d","e","f","g","h"].each do |letter|
      @board[letter+"2"] = Pawn.new("white")
      @board[letter+"7"] = Pawn.new("black")
    end
    p @board
  end
end

game_board = Board.new