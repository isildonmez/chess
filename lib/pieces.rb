require_relative 'board.rb'

class Piece
  attr_accessor :colour

  def initialize(colour)
    @colour = colour
  end
end

class Pawn < Piece
  attr_accessor :never_moved

  def initialize()
    @never_moved = true
  end

  def can_move(cur_coord, next_coord)
    return false if cur_coord[0] != next_coord[0]

    if self.colour == "white"
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

  def can_attack(cur_coord, next_coord)
    return false unless (cur_coord[0].ord + 1 == next_coord[0]) || (cur_coord[0].ord - 1 == next_coord[0])

    if self.colour == "white"
      return false unless cur_coord[1] + 1 == next_coord[1]
    else
      return false unless cur_coord[1] - 1 == next_coord[1]
    end

    return false if (board[next_coord].colour == board[cur_coord].colour) || (board[next_coord].nil?)
    return true
  end

  # TODO
  def en_passant
  end

  # TODO
  def pawn_promotion
  end

end

class Rook < Piece
  attr_accessor :never_moved

  def initialize()
    @never_moved = true
  end

end

class Bishop < Piece
end

class Knight < Piece
end

class Queen < Piece
end

class King < Piece
  attr_accessor :never_moved

  def initialize()
    @never_moved = true
  end
end