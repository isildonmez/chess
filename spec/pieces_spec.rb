require_relative '../lib/pieces'

describe Piece do

  describe Pawn do
    subject(:w_pawn1) {Pawn.new(:white)}
    subject(:w_pawn2) {Pawn.new(:white)}
    subject(:b_pawn1) {Pawn.new(:black)}
    subject(:b_pawn2) {Pawn.new(:black)}
  end


end