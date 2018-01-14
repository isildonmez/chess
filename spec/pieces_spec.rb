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
      expect(w_pawn.symbol).to eq("♟")
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

describe Rook do
  subject(:w_rook) {Rook.new(:white)}
  subject(:b_rook) {Rook.new(:black, false)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_rook.colour).to eq(:white)
      expect(b_rook.colour).to eq(:black)
    end

    it "sets its symbol" do
      expect(w_rook.symbol).to eq("♜")
      expect(b_rook.symbol).to eq("♜")
    end

    it "sets its never_moved" do
      expect(w_rook.never_moved).to eq(true)
      expect(b_rook.never_moved).to eq(false)
    end
  end

  describe "#can_move?" do
    it "returns false" do
      expect(b_rook.can_move?(:d6, :e7)).to eq(false)
      expect(w_rook.can_move?(:f5, :g1)).to eq(false)
    end

    it "returns true" do
      expect(b_rook.can_move?(:d6, :d1)).to eq(true)
      expect(w_rook.can_move?(:f2, :f8)).to eq(true)
    end
  end
end

describe Bishop do
  subject(:w_bishop) {Bishop.new(:white)}
  subject(:b_bishop) {Bishop.new(:black)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_bishop.colour).to eq(:white)
      expect(b_bishop.colour).to eq(:black)
    end

    it "sets its symbol" do
      expect(w_bishop.symbol).to eq("♝")
      expect(b_bishop.symbol).to eq("♝")
    end
  end

  describe "#can_move?" do
    it "returns false" do
      expect(b_bishop.can_move?(:d6, :e4)).to eq(false)
      expect(w_bishop.can_move?(:f5, :d4)).to eq(false)
    end

    it "returns true" do
      expect(w_bishop.can_move?(:e3, :b6)).to eq(true)
      expect(b_bishop.can_move?(:d5, :g8)).to eq(true)
    end
  end
end

describe Knight do
  subject(:w_knight) {Knight.new(:white)}
  subject(:b_knight) {Knight.new(:black)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_knight.colour).to eq(:white)
      expect(b_knight.colour).to eq(:black)
    end

    it "sets its symbol" do
      expect(w_knight.symbol).to eq("♞")
      expect(b_knight.symbol).to eq("♞")
    end
  end

  describe "#can_move?" do
    it "returns false" do
      expect(b_knight.can_move?(:c5, :d4)).to eq(false)
      expect(w_knight.can_move?(:c5, :e3)).to eq(false)
    end

    it "returns true" do
      expect(w_knight.can_move?(:c5, :e4)).to eq(true)
      expect(b_knight.can_move?(:c5, :d3)).to eq(true)
      expect(w_knight.can_move?(:c5, :b3)).to eq(true)
      expect(w_knight.can_move?(:c5, :a4)).to eq(true)
      expect(w_knight.can_move?(:c5, :a6)).to eq(true)
      expect(w_knight.can_move?(:c5, :b7)).to eq(true)
      expect(w_knight.can_move?(:c5, :d7)).to eq(true)
      expect(w_knight.can_move?(:c5, :e6)).to eq(true)
    end
  end
end

describe Queen do
  subject(:w_queen) {Queen.new(:white)}
  subject(:b_queen) {Queen.new(:black)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_queen.colour).to eq(:white)
      expect(b_queen.colour).to eq(:black)
    end

    it "sets its symbol" do
      expect(w_queen.symbol).to eq("♛")
      expect(b_queen.symbol).to eq("♛")
    end
  end

  describe "#can_move?" do
    it "returns false" do
      expect(b_queen.can_move?(:d6, :e4)).to eq(false)
      expect(w_queen.can_move?(:f5, :d4)).to eq(false)
    end

    it "returns true" do
      expect(w_queen.can_move?(:e3, :e8)).to eq(true)
      expect(w_queen.can_move?(:b3, :h3)).to eq(true)
      expect(b_queen.can_move?(:d3, :g6)).to eq(true)
    end
  end
end

describe King do
  subject(:w_king) {King.new(:white)}
  subject(:b_king) {King.new(:black, false)}

  describe "#initialize" do
    it "sets its colour" do
      expect(w_king.colour).to eq(:white)
      expect(b_king.colour).to eq(:black)
    end

    it "sets its symbol" do
      expect(w_king.symbol).to eq("♚")
      expect(b_king.symbol).to eq("♚")
    end

    it "sets its never_moved" do
      expect(w_king.never_moved).to eq(true)
      expect(b_king.never_moved).to eq(false)
    end

    it "sets its initial coord" do
      expect(w_king.coord).to eq(:e1)
      expect(b_king.coord).to eq(:e8)
    end

    it "sets its is_checked attr as false" do
      expect(w_king.is_checked).to eq(false)
      expect(b_king.is_checked).to eq(false)
    end
  end

  describe "#can_move?" do
    it "returns false" do
      expect(b_king.can_move?(:d6, :f6)).to eq(false)
      expect(w_king.can_move?(:f5, :f7)).to eq(false)
    end

    it "returns true" do
      expect(b_king.can_move?(:d4, :d5)).to eq(true)
      expect(b_king.can_move?(:d4, :d3)).to eq(true)
      expect(b_king.can_move?(:d4, :e4)).to eq(true)
      expect(b_king.can_move?(:d4, :c4)).to eq(true)
      expect(w_king.can_move?(:d4, :e3)).to eq(true)
      expect(w_king.can_move?(:d4, :e5)).to eq(true)
      expect(w_king.can_move?(:d4, :c3)).to eq(true)
      expect(w_king.can_move?(:d4, :c5)).to eq(true)
    end
  end
end
