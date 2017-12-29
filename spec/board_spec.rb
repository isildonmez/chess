require_relative '../lib/board'

describe Board do
  subject(:game) { Board.new }

  describe "#initialize" do
    it "sets the board hash" do
      expect(game.board[:a7].nil?).to eq(false)
      expect(game.board[:a3].nil?).to eq(true)
    end
  end

  describe "#get" do
    it "returns the symbol" do
      expect(game.get(:d2)).to eql("♙")
    end

    it "returns 1 space string" do
      expect(game.get(:b5)).to eql(" ")
    end
  end

end