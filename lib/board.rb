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
    lines =[["8 ┃ a8 ┃ b8 ┃ c8 ┃ d8 ┃ e8 ┃ f8 ┃ g8 ┃ h8 ┃ 8"],
            ["7 ┃ a7 ┃ b7 ┃ c7 ┃ d7 ┃ e7 ┃ f7 ┃ g7 ┃ h7 ┃ 7"],
            ["6 ┃ a6 ┃ b6 ┃ c6 ┃ d6 ┃ e6 ┃ f6 ┃ g6 ┃ h6 ┃ 6"],
            ["5 ┃ a5 ┃ b5 ┃ c5 ┃ d5 ┃ e5 ┃ f5 ┃ g5 ┃ h5 ┃ 5"],
            ["4 ┃ a4 ┃ b4 ┃ c4 ┃ d4 ┃ e4 ┃ f4 ┃ g4 ┃ h4 ┃ 4"],
            ["3 ┃ a3 ┃ b3 ┃ c3 ┃ d3 ┃ e3 ┃ f3 ┃ g3 ┃ h3 ┃ 3"],
            ["2 ┃ a2 ┃ b2 ┃ c2 ┃ d2 ┃ e2 ┃ f2 ┃ g2 ┃ h2 ┃ 2"],
            ["1 ┃ a1 ┃ b1 ┃ c1 ┃ d1 ┃ e1 ┃ f1 ┃ g1 ┃ h1 ┃ 1"]]
    middle_line  = ("  "+ "┣━━━" * 8 + "┫")
    bottom_line  = ("  " + "┗━━━" * 8 + "┛")
    body = lines.join("\n" + middle_line + "\n")

    empty_board = [horizontal_coordinates, top_line, body,
                    bottom_line, horizontal_coordinates].join("\n")
  end

  def update
  end
end

game = Board.new
puts game.visualise


