# Stores the coordinates of each player
# board[coord] = piece : nil, white_pawn2(instances)
require_relative './pieces'

class Board
  attr_accessor :board

  # TODO: other pieces
  def initialize()
    @board = {}
    ["a","b","c","d","e","f","g","h"].each do |letter|
      for hor in 3..6
        @board[(letter+"#{hor}").to_sym] = nil
      end
      @board[(letter+"2").to_sym] = Pawn.new(:white)
      @board[(letter+"7").to_sym] = Pawn.new(:black)
    end
  end

  def visualise
    horizontal_coordinates = "    " + ["a", "b", "c", "d", "e", "f", "g", "h"].join("   ")
    top_line     = ("  " + "┏━━━" * 8 + "┓")
    middle1   = ("┃   " * 8 + "┃")
    middle2   = ("┣━━━" * 8 + "┫")
    bottom_line  = ("  " + "┗━━━" * 8 + "┛")
    middle_lines  = []
    (8).downto(1) do |num|
      if num == 1
        middle_lines << ("#{num} " + middle1 + " #{num}")
        break
      else
        middle_lines << ("#{num} " + middle1 + " #{num}\n")
        middle_lines << ("  " + middle2 + "  \n")
      end
    end

    empty_board = [horizontal_coordinates, top_line, middle_lines.join,
                    bottom_line, horizontal_coordinates].join("\n")
  end

  def update
  end
end

game = Board.new
puts game.visualise


