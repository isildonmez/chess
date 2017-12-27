require_relative '../lib/pieces'

describe Pawn do
  subject(:w_pawn) {Pawn.new(:white)}
  subject(:b_pawn) {Pawn.new(:black)}
  let(:fake_board) { {:a6 => nil, :b5 => Pawn.new(:white), :c4 => Pawn.new(:black), :c5 => nil} }

  describe "#initialize" do
    it "sets its colour" do
      expect(w_pawn.colour).to eq(:white)
      expect(b_pawn.colour).to eq(:black)
    end
  end

  describe "#can_move" do
    it "returns false if coordinations are not on the same line" do
      expect(w_pawn.can_move(:a2, :b4, true)).to eq(false)
    end

    it "returns false if the vertical difference is higher than 2" do
      expect(w_pawn.can_move(:a3, :a6, true)).to eq(false)
      expect(b_pawn.can_move(:a7, :a2, true)).to eq(false)
    end

    it "returns false if moved before and if the vertical difference is equal to 2" do
      expect(b_pawn.can_move(:b6, :b4, true)).to eq(false)
    end

    it "returns false if coord is not free" do
      expect(w_pawn.can_move(:b4, :b5, fake_board[:b5].nil?)).to eq(false)

    end

    it "returns true if all the conditions are provided" do
      expect(fake_board[:c5].nil?).to eql(true)
      expect(fake_board[:a6].nil?).to eql(true)
      expect(b_pawn.can_move(:c7, :c5, true)).to eq(true)
      expect(w_pawn.can_move(:a5, :a6, true)).to eq(true)
    end

  end












end

