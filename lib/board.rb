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

  def get(coord)
    @board[coord].nil? ? " " : @board[coord].symbol
  end

  def visualise
    horizontal_coordinates = "    " + ["a", "b", "c", "d", "e", "f", "g", "h"].join("   ")
    top_line     = ("  " + "┏━━━" * 8 + "┓")
    lines =[["8 ┃ #{get(:a8)} ┃ #{get(:b8)} ┃ #{get(:c8)} ┃ #{get(:d8)} ┃ #{get(:e8)} ┃ #{get(:f8)} ┃ #{get(:g8)} ┃ #{get(:h8)} ┃ 8"],
            ["7 ┃ #{get(:a7)} ┃ #{get(:b7)} ┃ #{get(:c7)} ┃ #{get(:d7)} ┃ #{get(:e7)} ┃ #{get(:f7)} ┃ #{get(:g7)} ┃ #{get(:h7)} ┃ 7"],
            ["6 ┃ #{get(:a6)} ┃ #{get(:b6)} ┃ #{get(:c6)} ┃ #{get(:d6)} ┃ #{get(:e6)} ┃ #{get(:f6)} ┃ #{get(:g6)} ┃ #{get(:h6)} ┃ 6"],
            ["5 ┃ #{get(:a5)} ┃ #{get(:b5)} ┃ #{get(:c5)} ┃ #{get(:d5)} ┃ #{get(:e5)} ┃ #{get(:f5)} ┃ #{get(:g5)} ┃ #{get(:h5)} ┃ 5"],
            ["4 ┃ #{get(:a4)} ┃ #{get(:b4)} ┃ #{get(:c4)} ┃ #{get(:d4)} ┃ #{get(:e4)} ┃ #{get(:f4)} ┃ #{get(:g4)} ┃ #{get(:h4)} ┃ 4"],
            ["3 ┃ #{get(:a3)} ┃ #{get(:b3)} ┃ #{get(:c3)} ┃ #{get(:d3)} ┃ #{get(:e3)} ┃ #{get(:f3)} ┃ #{get(:g3)} ┃ #{get(:h3)} ┃ 3"],
            ["2 ┃ #{get(:a2)} ┃ #{get(:b2)} ┃ #{get(:c2)} ┃ #{get(:d2)} ┃ #{get(:e2)} ┃ #{get(:f2)} ┃ #{get(:g2)} ┃ #{get(:h2)} ┃ 2"],
            ["1 ┃ #{get(:a1)} ┃ #{get(:b1)} ┃ #{get(:c1)} ┃ #{get(:d1)} ┃ #{get(:e1)} ┃ #{get(:f1)} ┃ #{get(:g1)} ┃ #{get(:h1)} ┃ 1"]]
    middle_line  = ("  "+ "┣━━━" * 8 + "┫")
    bottom_line  = ("  " + "┗━━━" * 8 + "┛")
    body = lines.join("\n" + middle_line + "\n")

    visualised_board = [horizontal_coordinates, top_line, body,
                        bottom_line, horizontal_coordinates].join("\n")
  end

  def update
  end
end

game = Board.new
puts game.visualise


