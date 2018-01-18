require_relative './pieces'

class Board
  attr_accessor :board, :white_pieces, :black_pieces

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

    @white_pieces = {}
    @black_pieces = {}
    create_teams
  end

  def create_teams
    @board.each do |coord, obj|
      next if obj == nil
      @white_pieces[obj] = coord if obj.colour == :white
      @black_pieces[obj] = coord if obj.colour == :black
    end
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

  def get_pieces(colour, which_piece)
    which_piece = which_piece.to_s.capitalize
    if colour == :white
      return white_pieces.select{|obj, coord| obj.class.name == which_piece}
    else
      return black_pieces.select{|obj, coord| obj.class.name == which_piece}
    end
  end

  def update_teams(obj, value)
    if obj.colour == :white
      @white_pieces[obj] = value
    else
      @black_pieces[obj] = value
    end
  end

  def update(cur_coord, new_coord, game_turn)
    cur_piece = @board[cur_coord]

    # en_passant
    if (cur_piece.is_a? Pawn) && (en_passant?(cur_coord, new_coord, game_turn))
      opp_coord = opponent_coord(cur_coord, new_coord)
      opponent = @board[opp_coord]
      @white_pieces.delete(opponent) if opponent.colour == :white
      @black_pieces.delete(opponent) if opponent.colour == :black
      @board[opp_coord] = nil
    end

    # pawn_promotion
    if (cur_piece.is_a? Pawn) && (new_coord[1] == "1" || new_coord[1] == "8")
      return pawn_promotion(cur_coord, new_coord)
    end

    # castling
    if (cur_piece.is_a? King) && castling?(cur_coord, new_coord)
      update_rook_after_castling(new_coord)
    end

    other_piece = @board[new_coord]
    if other_piece
      @white_pieces.delete(other_piece) if other_piece.colour == :white
      @black_pieces.delete(other_piece) if other_piece.colour == :black
    end

    update_teams(cur_piece, new_coord)

    @board[new_coord] = @board[cur_coord]
    @board[cur_coord] = nil
    @board
  end

  def en_passant?(cur_coord, new_coord, game_turn)
    cur_piece = @board[cur_coord]
    return false unless cur_piece.can_attack?(cur_coord, new_coord)

    if @board[cur_coord].colour == :black
      return false if cur_coord[1].to_i != 4
    else
      return false if cur_coord[1].to_i != 5
    end

    opp_coord = opponent_coord(cur_coord, new_coord)
    return false if @board[opp_coord].nil?
    return false unless @board[opp_coord].is_a? Pawn
    return false unless (cur_piece.colour == :black && @board[opp_coord].colour == :white) ||
                        (cur_piece.colour == :white && @board[opp_coord].colour == :black)
    return false unless @board[opp_coord].turn_of_first_double_square == game_turn - 1
    true
  end

  def opponent_coord(cur_coord, new_coord)
    if @board[cur_coord].colour == :black
      opp_coord = (new_coord[0] + (new_coord[1].to_i + 1).to_s).to_sym
    else
      opp_coord = (new_coord[0] + (new_coord[1].to_i - 1).to_s).to_sym
    end
    opp_coord
  end

  def castling?(cur_coord, new_coord)
    cur_king = @board[cur_coord]
    cur_rook = nil
    rook_coord = nil
    return false if cur_king.is_checked == true
    return false unless cur_coord[1] == new_coord[1]

    if (new_coord[0] == "c" || new_coord[0] == "g") && cur_king.never_moved
      if new_coord[0] == "c"
        rook_coord = ("a" + new_coord[1]).to_sym
        cur_rook = @board[rook_coord]
      elsif new_coord[0] == "g"
        rook_coord = ("h" + new_coord[1]).to_sym
        cur_rook = @board[rook_coord]
      end
      return false unless cur_rook.is_a? Rook
      return false unless cur_rook.never_moved
      return false if cur_rook.colour != cur_king.colour
      return false unless empty_between?(cur_coord, rook_coord)
      return true
    end
    false
  end

  def update_rook_after_castling(new_coord)
    if new_coord[0] == "c"
      rook_cur_coord = ("a" + new_coord[1]).to_sym
      cur_rook = @board[rook_cur_coord]
      rook_new_coord = ("d" + new_coord[1]).to_sym
    elsif new_coord[0] == "g"
      rook_cur_coord = ("h" + new_coord[1]).to_sym
      cur_rook = @board[rook_cur_coord]
      rook_new_coord = ("f" + new_coord[1]).to_sym
    end
    update_teams(cur_rook, rook_new_coord)

    @board[rook_new_coord] = cur_rook
    @board[rook_cur_coord] = nil
    cur_rook.never_moved = false

    rook_new_coord
  end

  def pawn_promotion(cur_coord, new_coord, new_piece = pawn_to_be)
    cur_pawn = @board[cur_coord]
    update_teams(cur_pawn, nil)
    @board[new_coord] = Object.const_get(new_piece).new(cur_pawn.colour)
    promoted = @board[new_coord]
    update_teams(promoted, new_coord)
  end

  def pawn_to_be
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
          return false if @board[(i.chr + num).to_sym]
        end
      else
        for i in (new_coord[0].ord + 1)...(cur_coord[0].ord)
          return false if @board[(i.chr + num).to_sym]
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
          return false if @board[(letter + i.to_s).to_sym]
        end
      else
        for i in (new_coord[1].to_i + 1)...(cur_coord[1].to_i)
          return false if @board[(letter + i.to_s).to_sym]
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
          return false if @board[((cur_letter_ord + i).chr + (cur_num + i).to_s).to_sym]
        end
      else
        for i in 1...(difference.abs)
          return false if @board[((cur_letter_ord - i).chr + (cur_num - i).to_s).to_sym]
        end
      end
      return true
    end

    # Backward Diagonal
    if (cur_letter_ord - new_letter_ord).abs == (cur_num - new_num).abs
      if difference > 0
        for i in 1...difference
          return false if @board[((cur_letter_ord - i).chr + (cur_num + i).to_s).to_sym]
        end
      else
        for i in 1...(difference.abs)
          return false if @board[((cur_letter_ord + i).chr + (cur_num - i).to_s).to_sym]
        end
      end
      return true
    end

    return false
  end


end


