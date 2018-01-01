class Pawn
  attr_accessor :colour, :symbol, :turn_of_first_move

  def initialize(colour)
    @colour = colour
    @symbol = "♙" if @colour == :white
    @symbol = "♟" if @colour == :black
    @turn_of_first_move = nil
  end

  def can_move?(cur_coord, next_coord)
    return false if cur_coord[0] != next_coord[0]
    if self.colour == :white
      return false unless (cur_coord[1].to_i + 1 == next_coord[1].to_i) ||
                          (cur_coord[1].to_i + 2 == next_coord[1].to_i)
      return false if (cur_coord[1].to_i + 2 == next_coord[1].to_i) && !(cur_coord[1].to_i == 2)
    else
      return false unless (cur_coord[1].to_i - 1 == next_coord[1].to_i) ||
                          (cur_coord[1].to_i - 2 == next_coord[1].to_i)
      return false if (cur_coord[1].to_i - 2 == next_coord[1].to_i) && !(cur_coord[1].to_i == 7)
    end

    return true
  end

  def can_attack?(cur_coord, next_coord)
    if self.colour
    return false unless (cur_coord[0].ord + 1 == next_coord[0].ord) || (cur_coord[0].ord - 1 == next_coord[0].ord)

    if self.colour == :white
      return false unless cur_coord[1].to_i + 1 == next_coord[1].to_i
    else
      return false unless cur_coord[1].to_i - 1 == next_coord[1].to_i
    end

    return true
  end

  def en_passant?(game_turn, opponent_pawn)
    return false unless opponent_pawn.turn_of_first_move - game_turn == 1
    return true
  end

  # TODO: after other pieces
  def pawn_promotion
  end

end

class Rook
  attr_accessor :never_moved

  def initialize(never_moved = true)
    @never_moved = never_moved
  end

end

class Bishop
end

class Knight
end

class Queen
end

class King
  attr_accessor :never_moved

  def initialize(never_moved = true)
    @never_moved = never_moved
  end
end