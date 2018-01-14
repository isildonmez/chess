class Pawn
  attr_accessor :colour, :symbol, :turn_of_first_move

  def initialize(colour)
    @colour = colour
    @symbol = "♟"
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

end

class Rook
  attr_accessor :colour, :symbol, :never_moved

  def initialize(colour, never_moved = true)
    @colour = colour
    @symbol = "♜"
    @never_moved = never_moved
  end

  def can_move?(cur_coord, new_coord)
    return false unless ( (cur_coord[0] != new_coord[0] && cur_coord[1] == new_coord[1]) ||
                          (cur_coord[0] == new_coord[0] && cur_coord[1] != new_coord[1]) )
    return true
  end

end

class Bishop
  attr_accessor :colour, :symbol

  def initialize(colour)
    @colour = colour
    @symbol = "♝"
  end

  def can_move?(cur_coord, new_coord)
    return false unless ((cur_coord[0].ord - new_coord[0].ord).abs) == ((cur_coord[1].to_i - new_coord[1].to_i).abs)
    return true
  end

end

class Knight
  attr_accessor :colour, :symbol

  def initialize(colour)
    @colour = colour
    @symbol = "♞"
  end

  def can_move?(cur_coord, new_coord)
    to_add = [ [-1, -2], [1, -2], [1, 2], [-1, 2],
              [2, -1], [2, 1], [-2, 1], [-2, -1] ]
    possible_new_coords = to_add.map do |el|
      ( (cur_coord[0].ord + el[0]).chr + (cur_coord[1].to_i + el[1]).to_s ).to_sym
    end

    return possible_new_coords.include? new_coord
  end

end

class Queen
  attr_accessor :colour, :symbol

  def initialize(colour)
    @colour = colour
    @symbol = "♛"
  end

  def can_move?(cur_coord, new_coord)
    moves_as_a_rook = ( (cur_coord[0] != new_coord[0] && cur_coord[1] == new_coord[1]) ||
                          (cur_coord[0] == new_coord[0] && cur_coord[1] != new_coord[1]) )
    moves_as_a_bishop = ( ((cur_coord[0].ord - new_coord[0].ord).abs) == ((cur_coord[1].to_i - new_coord[1].to_i).abs) )
    return (moves_as_a_rook || moves_as_a_bishop)
  end

end

class King
  attr_accessor :colour, :symbol, :never_moved, :coord, :is_checked

  def initialize(colour, never_moved = true)
    @colour = colour
    @symbol = "♚"
    @never_moved = never_moved
    @coord = :e1 if @colour == :white
    @coord = :e8 if @colour == :black
    @is_checked = false
  end

  def can_move?(cur_coord, new_coord)
    to_add = [ [-1, 0], [1, 0], [0, -1], [0, 1],
              [1, -1], [1, 1], [-1, 1], [-1, -1] ]
    possible_new_coords = to_add.map do |el|
      ( (cur_coord[0].ord + el[0]).chr + (cur_coord[1].to_i + el[1]).to_s ).to_sym
    end

    return possible_new_coords.include? new_coord
  end

end






