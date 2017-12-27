require_relative '../lib/pieces'

describe Pawn do
  subject(:w_pawn1) {Pawn.new(:white, false)}
  subject(:w_pawn2) {Pawn.new(:white)}
  subject(:b_pawn1) {Pawn.new(:black, false)}
  subject(:b_pawn2) {Pawn.new(:black)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_pawn2.colour).to eq(:white)
      expect(b_pawn2.colour).to eq(:black)
    end

    it "sets its never_moved attr. as stated or by default" do
      expect(w_pawn1.never_moved).to eq(false)
      expect(w_pawn2.never_moved).to eq(true)
    end
  end












end

