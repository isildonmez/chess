class Pawn
  attr_accessor :colour, :symbol, :turn_of_first_move

  def initialize(colour)
    @colour = colour
    @symbol = "♟" if @colour == :white
    @symbol = "♙" if @colour == :black
    @turn_of_first_move = nil
  end

  def can_move?(cur_coord, new_coord)
    return false if cur_coord[0] != new_coord[0]
    if self.colour == :white
      return false unless (cur_coord[1].to_i + 1 == new_coord[1].to_i) ||
                          (cur_coord[1].to_i + 2 == new_coord[1].to_i)
      return false if (cur_coord[1].to_i + 2 == new_coord[1].to_i) && !(cur_coord[1].to_i == 2)
    else
      return false unless (cur_coord[1].to_i - 1 == new_coord[1].to_i) ||
                          (cur_coord[1].to_i - 2 == new_coord[1].to_i)
      return false if (cur_coord[1].to_i - 2 == new_coord[1].to_i) && !(cur_coord[1].to_i == 7)
    end

    return true
  end

  def can_attack?(cur_coord, new_coord)
    return false unless (cur_coord[0].ord + 1 == new_coord[0].ord) || (cur_coord[0].ord - 1 == new_coord[0].ord)

    if self.colour == :white
      return false unless cur_coord[1].to_i + 1 == new_coord[1].to_i
    else
      return false unless cur_coord[1].to_i - 1 == new_coord[1].to_i
    end

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
  attr_accessor :colour, :symbol

  def initialize(colour)
    @colour = colour
    @symbol = "♝" if @colour == :white
    @symbol = "♗" if @colour == :black
  end

  def can_move?(cur_coord, new_coord)
    return false unless ((cur_coord[0].ord - new_coord[0].ord).abs) == ((cur_coord[1].to_i - new_coord[1].to_i).abs)
    return true
  end
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