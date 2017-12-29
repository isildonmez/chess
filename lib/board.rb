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

  def sym(coord)
    @board[coord].nil? ? " " : @board[coord].symbol
  end

  def visualise
    horizontal_coordinates = "    " + ["a", "b", "c", "d", "e", "f", "g", "h"].join("   ")
    top_line     = ("  " + "┏━━━" * 8 + "┓")
    lines =[["8 ┃ #{sym(:a8)} ┃ #{sym(:b8)} ┃ #{sym(:c8)} ┃ #{sym(:d8)} ┃ #{sym(:e8)} ┃ #{sym(:f8)} ┃ #{sym(:g8)} ┃ #{sym(:h8)} ┃ 8"],
            ["7 ┃ #{sym(:a7)} ┃ #{sym(:b7)} ┃ #{sym(:c7)} ┃ #{sym(:d7)} ┃ #{sym(:e7)} ┃ #{sym(:f7)} ┃ #{sym(:g7)} ┃ #{sym(:h7)} ┃ 7"],
            ["6 ┃ #{sym(:a6)} ┃ #{sym(:b6)} ┃ #{sym(:c6)} ┃ #{sym(:d6)} ┃ #{sym(:e6)} ┃ #{sym(:f6)} ┃ #{sym(:g6)} ┃ #{sym(:h6)} ┃ 6"],
            ["5 ┃ #{sym(:a5)} ┃ #{sym(:b5)} ┃ #{sym(:c5)} ┃ #{sym(:d5)} ┃ #{sym(:e5)} ┃ #{sym(:f5)} ┃ #{sym(:g5)} ┃ #{sym(:h5)} ┃ 5"],
            ["4 ┃ #{sym(:a4)} ┃ #{sym(:b4)} ┃ #{sym(:c4)} ┃ #{sym(:d4)} ┃ #{sym(:e4)} ┃ #{sym(:f4)} ┃ #{sym(:g4)} ┃ #{sym(:h4)} ┃ 4"],
            ["3 ┃ #{sym(:a3)} ┃ #{sym(:b3)} ┃ #{sym(:c3)} ┃ #{sym(:d3)} ┃ #{sym(:e3)} ┃ #{sym(:f3)} ┃ #{sym(:g3)} ┃ #{sym(:h3)} ┃ 3"],
            ["2 ┃ #{sym(:a2)} ┃ #{sym(:b2)} ┃ #{sym(:c2)} ┃ #{sym(:d2)} ┃ #{sym(:e2)} ┃ #{sym(:f2)} ┃ #{sym(:g2)} ┃ #{sym(:h2)} ┃ 2"],
            ["1 ┃ #{sym(:a1)} ┃ #{sym(:b1)} ┃ #{sym(:c1)} ┃ #{sym(:d1)} ┃ #{sym(:e1)} ┃ #{sym(:f1)} ┃ #{sym(:g1)} ┃ #{sym(:h1)} ┃ 1"]]
    middle_line  = ("  "+ "┣━━━" * 8 + "┫")
    bottom_line  = ("  " + "┗━━━" * 8 + "┛")
    body = lines.join("\n" + middle_line + "\n")

    visualised_board = [horizontal_coordinates, top_line, body,
                        bottom_line, horizontal_coordinates].join("\n")
  end

  def coord_occupied?(coord)
    return @board[coord].nil? ? false : true
  end

  def update(cur_coord, next_coord)
    @board[next_coord] = @board[cur_coord]
    @board[cur_coord] = nil
    @board
  end
end


