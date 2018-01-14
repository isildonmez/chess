require_relative './pieces'

class Board
  attr_accessor :board, :white_king, :black_king

  def initialize()
    @board = {}
    ["a","b","c","d","e","f","g","h"].each do |letter|
      for hor in 3..6
        @board[(letter+"#{hor}").to_sym] = nil
      end
      @board[(letter+"2").to_sym] = Pawn.new(:white)
      @board[(letter+"7").to_sym] = Pawn.new(:black)
    end
    @board[:a1] = Rook.new(:white)
    @board[:h1] = Rook.new(:white)
    @board[:a8] = Rook.new(:black)
    @board[:h8] = Rook.new(:black)

    @board[:b1] = Knight.new(:white)
    @board[:g1] = Knight.new(:white)
    @board[:b8] = Knight.new(:black)
    @board[:g8] = Knight.new(:black)

    @board[:c1] = Bishop.new(:white)
    @board[:f1] = Bishop.new(:white)
    @board[:c8] = Bishop.new(:black)
    @board[:f8] = Bishop.new(:black)

    @board[:d1] = Queen.new(:white)
    @board[:d8] = Queen.new(:black)

    @board[:e1] = King.new(:white)
    @board[:e8] = King.new(:black)

    @white_king = @board[:e1]
    @black_king = @board[:e8]
  end

  def get(coord)
    @board[coord]
  end

  def sym(coord)
    return " " if @board[coord].nil?
    if @board[coord].colour == :white
      "\e[97m#{@board[coord].symbol}"
    else
      "\e[30m#{@board[coord].symbol}"
    end
  end

  def visualise
    horizontal_coordinates = "    " + ["a", "b", "c", "d", "e", "f", "g", "h"].join("   ")
    top_line     = ("  " + "┏━━━" * 8 + "┓")
    basic_lines = (["┃." * 8 + "┃"] * 8 )
    basic_lines = basic_lines.map.with_index do |line, ord|
      "#{8 - ord} " + line + " #{8 - ord}"
    end

    basic_lines = basic_lines.map do |line|
      line_no = line[0].to_i
      for i in 0...4
        coord1 = ((97 +    i * 2   ).chr + "#{line_no}").to_sym
        coord2 = ((97 + (i * 2 + 1)).chr + "#{line_no}").to_sym
        if line_no.even?
          line = line.sub ".", "\e[104m #{sym(coord1)} \e[0m"
          line = line.sub ".", "\e[103m #{sym(coord2)} \e[0m"
        else
          line = line.sub ".", "\e[103m #{sym(coord1)} \e[0m"
          line = line.sub ".", "\e[104m #{sym(coord2)} \e[0m"
        end
      end
      line
    end

    middle_line  = ("  "+ "┣━━━" * 8 + "┫")
    bottom_line  = ("  " + "┗━━━" * 8 + "┛")
    body = basic_lines.join("\n" + middle_line + "\n")

    visualised_board = [horizontal_coordinates, top_line, body,
                        bottom_line, horizontal_coordinates].join("\n")
  end

  def coord_occupied?(coord)
    return @board[coord].nil? ? false : true
  end

  # TODO: update acc to each team's pieces and its test
  def get_the_king(colour)
    return @white_king if colour == :white
    return @black_king if colour == :black
  end

  # TODO: update acc to each team's pieces and its test
  def update(cur_coord, new_coord)
    cur_piece = @board[cur_coord]
    if (cur_piece.is_a? King)
      cur_piece.coord = new_coord
    end
    @board[new_coord] = @board[cur_coord]
    @board[cur_coord] = nil
    @board
  end

  # TODO: change updating the opponent pawn and its test
  def en_passant?(cur_coord, new_coord, game_turn)
    cur_piece = @board[cur_coord]
    return false unless cur_piece.can_attack?(cur_coord, new_coord)

    if @board[cur_coord].colour == :black

      return false if cur_coord[1].to_i != 4
      opponent_coord = (new_coord[0] + (new_coord[1].to_i + 1).to_s).to_sym
    else

      return false if cur_coord[1].to_i != 5
      opponent_coord = (new_coord[0] + (new_coord[1].to_i - 1).to_s).to_sym
    end
    return false if @board[opponent_coord].nil?
    return false unless @board[opponent_coord].is_a? Pawn
    return false unless (cur_piece.colour == :black && @board[opponent_coord].colour == :white) ||
                        (cur_piece.colour == :white && @board[opponent_coord].colour == :black)
    return false unless @board[opponent_coord].turn_of_first_move == game_turn - 1

    @board[opponent_coord] = nil
    true
  end

  # TODO: change updating castle's coord and its test
  def castling?(cur_coord, new_coord)
    cur_piece = @board[cur_coord]
    if (new_coord[0] == "c" || new_coord[0] == "g") && cur_piece.never_moved
      return false unless cur_coord[1] == new_coord[1]
      if new_coord[0] == "c"
        return false unless @board[("a" + new_coord[1]).to_sym].is_a? Rook
        cur_rook = @board[("a" + new_coord[1]).to_sym]
        return false unless cur_rook.never_moved
        return false if cur_rook.colour != cur_piece.colour
        return false unless empty_between?(cur_coord, ("a" + new_coord[1]).to_sym)
        @board[("d" + new_coord[1]).to_sym] = cur_rook
        @board[("a" + new_coord[1]).to_sym] = nil
      elsif new_coord[0] == "g"
        return false unless @board[("h" + new_coord[1]).to_sym].is_a? Rook
        cur_rook = @board[("h" + new_coord[1]).to_sym]
        return false unless cur_rook.never_moved
        return false if cur_rook.colour != cur_piece.colour
        return false unless empty_between?(cur_coord, ("h" + new_coord[1]).to_sym)
        @board[("f" + new_coord[1]).to_sym] = cur_rook
        @board[("h" + new_coord[1]).to_sym] = nil
      end
      cur_rook.never_moved = false
      return true
    end
    false
  end

  def pawn_promotion(new_coord, new_piece = which_piece)
    cur_pawn = @board[new_coord]
    @board[new_coord] = Object.const_get(new_piece).new(cur_pawn.colour)
  end

  def which_piece
    puts "Please which piece of the following do you want your pawn to transform  into?"
    puts "Enter 1 for Queen, enter 2 for Knight, enter 3 for Rook, enter 4 for Bishop"
    order = gets.chomp
    until (order.is_a? Integer) && (order.between?(0,3))
      puts "Please enter a valid number"
      puts "Enter 0 for Queen, enter 1 for Knight, enter 2 for Rook, enter 3 for Bishop"
      order = gets.chomp
    end
    pieces = ["Queen", "Knight", "Rook", "Bishop"]
    pieces[order]
  end

  def empty_between?(cur_coord, new_coord)
    # Horizontal
    if cur_coord[1] == new_coord[1]
      num = cur_coord[1]
      return true if (new_coord[0].ord - cur_coord[0].ord).abs == 1
      if new_coord[0].ord > cur_coord[0].ord
        for i in (cur_coord[0].ord + 1)...(new_coord[0].ord)
          return false unless @board[(i.chr + num).to_sym].nil?
        end
      else
        for i in (new_coord[0].ord + 1)...(cur_coord[0].ord)
          return false unless @board[(i.chr + num).to_sym].nil?
        end
      end
      return true
    end

    # Vertical
    if cur_coord[0] == new_coord[0]
      letter = cur_coord[0]
      return true if (new_coord[1].to_i - cur_coord[1].to_i).abs == 1
      if new_coord[1].to_i > cur_coord[1].to_i
        for i in (cur_coord[1].to_i + 1)...(new_coord[1].to_i)
          return false unless @board[(letter + i.to_s).to_sym].nil?
        end
      else
        for i in (new_coord[1].to_i + 1)...(cur_coord[1].to_i)
          return false unless @board[(letter + i.to_s).to_sym].nil?
        end
      end
      return true
    end

    cur_letter_ord = cur_coord[0].ord
    cur_num = cur_coord[1].to_i
    new_letter_ord = new_coord[0].ord
    new_num = new_coord[1].to_i
    difference = new_num - cur_num
    return true if (difference).abs == 1

    # Forward Diagonal
    if (cur_letter_ord - new_letter_ord) == (cur_num - new_num)
      if difference > 0
        for i in 1...difference
          return false unless @board[((cur_letter_ord + i).chr + (cur_num + i).to_s).to_sym].nil?
        end
      else
        for i in 1...(difference.abs)
          return false unless @board[((cur_letter_ord - i).chr + (cur_num - i).to_s).to_sym].nil?
        end
      end
      return true
    end

    # Backward Diagonal
    if (cur_letter_ord - new_letter_ord).abs == (cur_num - new_num).abs
      if difference > 0
        for i in 1...difference
          return false unless @board[((cur_letter_ord - i).chr + (cur_num + i).to_s).to_sym].nil?
        end
      else
        for i in 1...(difference.abs)
          return false unless @board[((cur_letter_ord + i).chr + (cur_num - i).to_s).to_sym].nil?
        end
      end
      return true
    end

    return false
  end


end


