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

  def take_coordinates(player)
    puts "#{player.capitalize} player, please enter the coordinate of a piece you want to move. (e.g. a4)"
    cur_coord = gets.chomp.to_sym
    until (valid_and_occupied?(cur_coord) && right_coloured_piece(player, cur_coord))
      puts "It has to be empty and the piece has to be from your pieces. Please enter a valid coordinate.(e.g. a4, d5)"
      cur_coord = gets.chomp.to_sym
    end
    puts "#{player.capitalize} player, please enter a new coordinate in order to make a legal move. (e.g. b6)"
    new_coord = gets.chomp.to_sym
    until valid_coord?(new_coord)
      puts "It has to be valid. Please enter another coordinate.(e.g. a4, d5)"
      new_coord = gets.chomp.to_sym
    end
    [cur_coord, new_coord]
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
      return false unless @board.empty_path?(cur_coord, new_coord)
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
      return true
    else
      return false
    end
  end

  # TODO
  def check_mate?(player, turn)
    opp_player = player == :white ? :black : :white
    return false unless @board.get_all_about_king(opp_player).first.is_checked
    return false unless king_can_move_to(opp_player, turn).empty?
    return false if piece_can_be_eaten?(player,turn)
    return false if any_piece_can_move_between?(player, turn)
    true
  end

  def king_can_move_to(player, turn)
    coord = @board.get_all_about_king(player).last
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

  def piece_can_be_eaten?(player, turn)
    team = player == :white ? @board.white_pieces : @board.black_pieces
    pieces_checks_the_king = team.select{|obj, coord| checks_the_opponent_king?(coord, turn)}
    return false if pieces_checks_the_king.length > 1
    coord = pieces_checks_the_king.values.first

    opp_team = player == :white ? @board.black_pieces : @board.white_pieces
    opp_pieces_eat_it = opp_team.values.select{|opp_coord| legal_move(opp_coord, coord, turn)}
    opp_pieces_eat_it.each do |opp_coord|
      return true if !its_king_checked?(opp_coord, coord, turn)
    end
    false
  end

  def any_piece_can_move_between?(player, turn)
    team = player == :white ? @board.white_pieces : @board.black_pieces
    pieces_checks_the_king = team.select{|obj, coord| checks_the_opponent_king?(coord, turn)}
    return false if pieces_checks_the_king.length > 1
    return false if pieces_checks_the_king.keys.first.is_a? Knight
    threatening_coord = pieces_checks_the_king.values.first

    opp_team = player == :white ? @board.black_pieces : @board.white_pieces
    opp_player = player == :white ? :black : :white
    king_coord = @board.get_all_about_king(opp_player).last
    path = @board.path_between(threatening_coord, king_coord).flatten
    return false if path.empty?

    opp_team.values.each do |piece_coord|
      path.each do |square|
        return true if legal_move(piece_coord, square, turn) &&
                      !its_king_checked?(piece_coord, square, turn)
      end
    end
    false
  end

  def stalemate?(player, turn)
    opp_player = player == :white ? :black : :white
    return false if board.get_all_about_king(opp_player)[0].is_checked
    return true if (king_can_move_to(opp_player, turn).empty?) &&
                    !piece_can_be_eaten?(player,turn) &&
                    !any_piece_can_move_between?(player, turn)
  end

end

if __FILE__ == $0
  chess = Game.new(Board.new)
  puts chess.rules
  puts chess.board.visualise
  game_over = false
  turn = 0

  until game_over
    turn += 1
    player = turn.odd? ? :white : :black
    accepted_move = false

    until accepted_move
      coordinates = chess.take_coordinates(player)
      cur_coord = coordinates[0]
      new_coord = coordinates[1]
      next unless chess.legal_move(cur_coord, new_coord, turn)

      if chess.its_king_checked?(cur_coord, new_coord, turn)
        puts "Your king is checked!"
        next
      end
      chess.board.get_all_about_king(player)[0].is_checked = false

      accepted_move = true
    end

    chess.board.update(cur_coord, new_coord, turn)
    puts chess.board.visualise
    # TODO: check if different moves or different pieces are possible)

    if chess.check_mate?(player, turn)
      puts "CHECKMATE!"
      puts "Congratulations #{player.capitalize} player!"
      game_over = true
    elsif chess.stalemate?(player, turn)
      puts "STALEMATE!"
      game_over = true
    elsif chess.checks_the_opponent_king?(new_coord, turn)
      chess.board.get_all_about_king(player)[0].is_checked = true
      puts "#{player.capitalize} checked the King"
    end
  end

end





