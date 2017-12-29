require_relative '../lib/board'

describe Board do
  subject(:b) { Board.new }

  describe "#initialize" do
    it "sets the board hash" do
      expect(b.board[:a7].nil?).to eql(false)
      expect(b.board[:a3].nil?).to eql(true)
    end
  end

  describe "#sym" do
    it "returns the symbol" do
      expect(b.sym(:d2)).to eql("♙")
    end

    it "returns 1 space string" do
      expect(b.sym(:b5)).to eql(" ")
    end
  end

  describe "#update" do
    it "returns updated board" do
      expect(b.board[:a4]).to eql(nil)
      a_pawn = b.board[:a2]
      b.update(:a2, :a4)
      expect(b.board[:a2]).to eql(nil)
      expect(b.board[:a4]).to eql(a_pawn)
    end
  end

end