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

  def valid_coord?(coord)
    return false if coord.length != 2
    return false unless ["a", "b", "c", "d", "e", "f", "g", "h"].include?(coord[0])
    return false unless ["1", "2", "3", "4", "5", "6", "7", "8"].include?(coord[1])
    return true
  end

  def valid_and_occupied?(coord)
    return false unless valid_coord?(coord)
    return false unless @board.coord_occupied?(coord)
    return true
  end

  # TODO
  def a_winner?(player)
    return game_over = false
  end

end

if __FILE__ == $0
  chess = Game.new(Board.new)
  puts chess.rules
  puts @board.visualise
  game_over = false
  turn = 1
  accepted_move = false

  until game_over
    player = turn.odd? ? :white : :black

    until accepted_move
      puts "#{player} player, please enter a coordinate of a piece you want to move. (e.g. a4)"
      cur_coord = gets.chomp.to_sym
      until chess.valid_and_occupied?(cur_coord)
        puts "Please enter a valid coordinate which is also not empty. (e.g. a4, d5)"
        cur_coord = gets.chomp.to_sym
      end
      puts "#{player} player, please enter a new coordinate as a move for this piece. (e.g. b6)"
      new_coord = gets.chomp.to_sym
      until chess.valid_coord?(new_coord)
        puts "Please enter a valid coordinate"
        new_coord = gets.chomp.to_sym
      end

      cur_piece = @board[cur_coord]
      if @board[new_coord].nil?
        next unless cur_piece.can_move?(cur_coord, new_coord)
      else
        next if cur_piece.colour == @board[new_coord].colour
        next unless cur_piece.can_attack?(cur_coord, new_coord)
      end

      next unless @board.empty_between?(cur_coord, new_coord)
      accepted_move = true


    end
    accepted_move = false
    a_winner?(player)
  end

end





