require_relative 'pieces'
require_relative 'board'

class Game
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def rules
    "Welcome to chess game!\n" +
    "Each player should play by turns\n" +
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

  def right_coloured_piece(player, coord)
    return player == @board.get(coord).colour ? true : false
  end

end

if __FILE__ == $0
  chess = Game.new(Board.new)
  puts chess.rules
  puts chess.board.visualise
  game_over = false
  turn = 1
  accepted_move = false

  until game_over
    player = turn.odd? ? :white : :black

    until accepted_move
      puts "#{player.capitalize} player, please enter the coordinate of a piece you want to move. (e.g. a4)"
      cur_coord = gets.chomp.to_sym
      until (chess.valid_and_occupied?(cur_coord) && chess.right_coloured_piece(player, cur_coord))
        puts "It has to be empty and the piece has to be from your pieces. Please enter a valid coordinate.(e.g. a4, d5)"
        cur_coord = gets.chomp.to_sym
      end
      puts "#{player.capitalize} player, please enter a new coordinate. (e.g. b6)"
      new_coord = gets.chomp.to_sym
      until chess.valid_coord?(new_coord)
        puts "It has to be valid. Please enter another coordinate.(e.g. a4, d5)"
        new_coord = gets.chomp.to_sym
      end

      if (cur_piece.is_a? Knight == false)
        next unless chess.board.empty_between?(cur_coord, new_coord)
      end

      cur_piece = chess.board.get(cur_coord)
      if chess.board.get(new_coord).nil?
        if cur_piece.is_a? Pawn
          next unless (chess.board.en_passant?(cur_coord, new_coord, turn)) ||
                      cur_piece.can_move?(cur_coord, new_coord)
        elsif cur_piece.is_a? King
          next unless (chess.board.castling?(cur_coord, new_coord) ||
                      cur_piece.can_move?(cur_coord, new_coord))
        else
          next unless cur_piece.can_move?(cur_coord, new_coord)
        end
      else
        next if cur_piece.colour == chess.board.get(new_coord).colour
        next unless cur_piece.can_attack?(cur_coord, new_coord)
      end


      accepted_move = true
      cur_piece.turn_of_first_move = turn if (cur_piece.is_a? Pawn) &&
                                              (cur_coord[0] == new_coord[0]) &&
                                              ((cur_coord[1].to_i - new_coord[1].to_i).abs == 2)
      cur_piece.never_moved = false if (cur_piece.is_a? Rook) || (cur_piece.is_a? King)
    end

    chess.board.update(cur_coord, new_coord)
    puts chess.board.visualise
    chess.a_winner?(player)
    accepted_move = false
    turn += 1
  end

end





