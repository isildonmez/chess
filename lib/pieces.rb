class Pawn
  attr_accessor :colour, :symbol

  def initialize(colour)
    @colour = colour
    @symbol = "♙" if @colour == :white
    @symbol = "♟" if @colour == :black
  end

  def can_move(cur_coord, next_coord, free_coord)
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

    return false unless free_coord
    return true
  end

  def can_attack(cur_coord, next_coord, same_colour)
    return false unless (cur_coord[0].ord + 1 == next_coord[0].ord) || (cur_coord[0].ord - 1 == next_coord[0].ord)

    if self.colour == :white
      return false unless cur_coord[1].to_i + 1 == next_coord[1].to_i
    else
      return false unless cur_coord[1].to_i - 1 == next_coord[1].to_i
    end

    return false if same_colour
    return true
  end

  # TODO
  def en_passant
  end

  # TODO
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