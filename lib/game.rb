require_relative 'pieces'
require_relative 'board'

# never_moved = false if can_move || can_attack == true
# check en passant if one of the pawn is on the 4/5th rank

class Game

  def initialize(board)
    @board = board
  end

  def rules
    "Welcome to chess game!\n"
    "Each player should play by turns\n"
    "And white player plays first\n"
  end

  def check_cur_coord(cur_coord)
    return :invalid if cur_coord.length != 2
    return :invalid unless ["a", "b", "c", "d", "e", "f", "g", "h"].include?(cur_coord[0])
    return :invalid unless ["1", "2", "3", "4", "5", "6", "7", "8"].include?(cur_coord[1])
    return :occupied unless @board.coord_occupied?(cur_coord)
    return :valid
  end

  def check_new_coord(new_coord)
    return :invalid if new_coord.length != 2
    return :invalid unless ["a", "b", "c", "d", "e", "f", "g", "h"].include?(new_coord[0])
    return :invalid unless ["1", "2", "3", "4", "5", "6", "7", "8"].include?(new_coord[1])
    return :valid
  end

end

if __FILE__ == $0
  chess = Game.new(Board.new)
  puts chess.rules
  puts b.visualise

  puts "Please enter a coordinate of a piece you want to move. (e.g. a4)"
  cur_coord = gets.chomp.to_sym
  until chess.check_cur_coord(cur_coord) == :valid
    puts "Please enter a coordinate that is not empty" if check_cur_coord(cur_coord) == :occupied
    puts "Please enter a valid coordinate. (e.g. a4, d5)" unless check_cur_coord(cur_coord) == :invalid
    cur_coord = gets.chomp.to_sym
  end
  puts "Please enter a new coordinate for this piece. (e.g. b6)"
  new_coord = gets.chomp.to_sym
  until chess.check_new_coord(new_coord) == :valid
    puts "Please enter a valid coordinate"
    new_coord = gets.chomp.to_sym
  end

end
