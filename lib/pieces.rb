class Pawn
  attr_accessor :never_moved

  def initialize(colour, never_moved = true)
    @colour = colour
    @never_moved = never_moved
  end

  def can_move(cur_coord, next_coord)
    return false if cur_coord[0] != next_coord[0]

    if self.colour == :white
      return false unless (cur_coord[1].to_i + 1 == next_coord[1].to_i) ||
                          (cur_coord[1].to_i + 2 == next_coord[1].to_i)
      return false if (cur_coord[1].to_i + 2 == next_coord[1].to_i) && never_moved
    else
      return false unless (cur_coord[1].to_i - 1 == next_coord[1].to_i) ||
                          (cur_coord[1].to_i - 2 == next_coord[1].to_i)
      return false if (cur_coord[1].to_i - 2 == next_coord[1].to_i) && never_moved
    end

    return false unless next_coord.nil?
    return true
  end

  def can_attack(cur_coord, next_coord, same_colour)
    return false unless (cur_coord[0].ord + 1 == next_coord[0]) || (cur_coord[0].ord - 1 == next_coord[0])

    if self.colour == :white
      return false unless cur_coord[1] + 1 == next_coord[1]
    else
      return false unless cur_coord[1] - 1 == next_coord[1]
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