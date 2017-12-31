require_relative '../lib/pieces'

describe Pawn do
  subject(:w_pawn) {Pawn.new(:white)}
  subject(:b_pawn) {Pawn.new(:black)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_pawn.colour).to eq(:white)
      expect(b_pawn.colour).to eq(:black)
    end

    it "sets its symbol" do
      expect(w_pawn.symbol).to eq("♙")
      expect(b_pawn.symbol).to eq("♟")
    end
  end

  describe "#can_move?" do
    it "returns false if coordinations are not on the same line" do
      expect(w_pawn.can_move?(:a2, :b4)).to eq(false)
    end

    it "returns false if the vertical difference is higher than 2" do
      expect(w_pawn.can_move?(:a3, :a6)).to eq(false)
      expect(b_pawn.can_move?(:a7, :a2)).to eq(false)
    end

    it "returns false if moved before and if the vertical difference is equal to 2" do
      expect(b_pawn.can_move?(:b6, :b4)).to eq(false)
    end

    it "returns true if all the conditions are provided" do
      expect(b_pawn.can_move?(:c7, :c5)).to eq(true)
      expect(w_pawn.can_move?(:a5, :a6)).to eq(true)
    end
  end

  describe "#can_attack?" do
    it "returns false when the coordinate letters are not in a row" do
      expect(w_pawn.can_attack?(:a4, :c5)).to eql(false)
      expect(b_pawn.can_attack?(:d6, :b5)).to eql(false)
    end

    context "when white" do
      it "returns false" do
        expect(w_pawn.can_attack?(:a4, :b6)).to eql(false)
      end
    end

    context "when black" do
      it "returns false" do
        expect(b_pawn.can_attack?(:d6, :c4)).to eql(false)
      end
    end

    it "returns true" do
      expect(w_pawn.can_attack?(:d5, :e6)).to eq(true)
      expect(b_pawn.can_attack?(:e6, :d5)).to eq(true)
    end
  end



end

