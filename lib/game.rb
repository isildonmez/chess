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

  def right_coloured_piece(player, coord)
    return player == @board.get(coord).colour ? true : false
  end

  def free_way(cur_coord, new_coord)
    cur_piece = @board.get(cur_coord)
    if !(cur_piece.is_a? Knight)
      return false unless @board.empty_between?(cur_coord, new_coord)
    end
    true
  end

  def valid_move_of_the_piece(cur_coord, new_coord, turn)
    cur_piece = @board.get(cur_coord)
    if @board.get(new_coord).nil?
      if cur_piece.is_a? Pawn
        return false unless (@board.en_passant?(cur_coord, new_coord, turn)) ||
                            cur_piece.can_move?(cur_coord, new_coord)
      elsif cur_piece.is_a? King
        return false unless (@board.castling?(cur_coord, new_coord) ||
                            cur_piece.can_move?(cur_coord, new_coord))
        return false if (@board.castling?(cur_coord, new_coord)) &&
                        (cur_piece.is_checked)
      else
        return false unless cur_piece.can_move?(cur_coord, new_coord)
      end
    else
      return false if cur_piece.colour == @board.get(new_coord).colour
      if cur_piece.is_a? Pawn
        return false unless cur_piece.can_attack?(cur_coord, new_coord)
      else
        return false unless cur_piece.can_move?(cur_coord, new_coord)
      end
    end
    true
  end

  def legal_move(cur_coord, new_coord, turn)
    free_way(cur_coord, new_coord) && valid_move_of_the_piece(cur_coord, new_coord, turn)
  end

  def revert_board(real_board, real_whites, real_blacks)
    @board.board = real_board
    @board.white_pieces = real_whites
    @board.black_pieces = real_blacks
  end

  def its_king_checked?(cur_coord, new_coord, turn)
    real_board = @board.board.clone
    real_whites = @board.white_pieces.clone
    real_blacks = @board.black_pieces.clone

    @board.update(cur_coord, new_coord, turn)
    cur_piece = @board.get(new_coord)
    its_king = @board.get_all_about_king(cur_piece.colour).first
    king_coord = @board.get_all_about_king(cur_piece.colour).last
    opponent_team = cur_piece.colour == :white ? @board.black_pieces : @board.white_pieces

    opponent_team.each do |piece, coord|
      if legal_move(coord, king_coord, turn)
        revert_board(real_board, real_whites, real_blacks)
        return true
      end
    end
    revert_board(real_board, real_whites, real_blacks)
    false
  end

  def checks_the_opponent_king?(new_coord, turn)
    cur_piece = @board.get(new_coord)
    king_colour = cur_piece.colour == :white ? :black : :white
    opp_king = @board.get_all_about_king(king_colour).first
    king_coord = @board.get_all_about_king(king_colour).last
    if legal_move(new_coord, king_coord, turn)
      @board.get(king_coord).is_checked = true
      return true
    else
      return false
    end
  end

  # TODO
  def check_mate(colour, turn)
    opp_colour = colour == :white ? :black : :white
    return false unless @board.get_all_about_king(opp_colour).first.is checked?
    return false unless king_can_move_to(opp_colour, turn).empty?
    return false if piece_can_be_eaten?(colour,turn)
    return false if any_piece_moves_between?
    return true
  end

  def king_can_move_to(colour, turn)
    coord = @board.get_all_about_king(colour).last
    letters = [(coord[0].ord - 1), (coord[0].ord), (coord[0].ord + 1)].select{|num| num.between?(97, 104)}.map{|num| num.chr}
    nums = [(coord[1].to_i - 1), (coord[1].to_i), (coord[1].to_i + 1)].select{|num| num.between?(1,8)}.map(&:to_s)

    possible_coords = []
    letters.each do |letter|
      nums.each do |num|
        possible_coords << ((letter + num).to_sym)
      end
    end
    possible_coords -= [coord]

    possible_coords = possible_coords.select{|pos_coord| !its_king_checked?(coord, pos_coord, turn)}
    possible_coords
  end

  def piece_can_be_eaten?(colour, turn)
    team = colour == :white ? @board.white_pieces : @board.black_pieces
    pieces_checks_the_king = team.select{|obj, coord| checks_the_opponent_king?(coord, turn)}
    return false if pieces_checks_the_king.length > 1
    coord = pieces_checks_the_king.values.first

    opp_team = colour == :white ? @board.black_pieces : @board.white_pieces
    opp_pieces_eat_it = opp_team.values.select{|opp_coord| legal_move(opp_coord, coord, turn)}
    opp_pieces_eat_it.each do |opp_coord|
      return true if !its_king_checked?(opp_coord, coord, turn)
    end
    false
  end

  def any_piece_can_move_between
  end

  # TODO
  def a_winner?(player)
    return game_over = false
  end

end

if __FILE__ == $0
  chess = Game.new(Board.new)
  puts chess.rules
  puts chess.board.visualise
  game_over = false
  turn = 1

  until game_over
    player = turn.odd? ? :white : :black
    accepted_move = false

    # TODO: if its king checked
    until accepted_move
      puts "#{player.capitalize} player, please enter the coordinate of a piece you want to move. (e.g. a4)"
      cur_coord = gets.chomp.to_sym
      until (chess.valid_and_occupied?(cur_coord) && chess.right_coloured_piece(player, cur_coord))
        puts "It has to be empty and the piece has to be from your pieces. Please enter a valid coordinate.(e.g. a4, d5)"
        cur_coord = gets.chomp.to_sym
      end
      puts "#{player.capitalize} player, please enter a new coordinate in order to make a legal move. (e.g. b6)"
      new_coord = gets.chomp.to_sym
      until chess.valid_coord?(new_coord)
        puts "It has to be valid. Please enter another coordinate.(e.g. a4, d5)"
        new_coord = gets.chomp.to_sym
      end

      next unless chess.legal_move(cur_coord, new_coord, turn)
      if chess.its_king_checked?(cur_coord, new_coord, turn)
        # if stalemate?(check if different moves or different pieces are possible)
        #   finish game
        # else
        #   next
        # end
      end

      accepted_move = true
      chess.board.update(cur_coord, new_coord, turn)
      chess.checks_the_opponent_king?(new_coord, turn)
    end

    puts chess.board.visualise
    chess.a_winner?(player)
    accepted_move = false
    turn += 1
  end

end





