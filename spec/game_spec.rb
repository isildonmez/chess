require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:chess) { Game.new(Board.new) }


  describe "#valid_and_occupied?" do
    it "returns false" do
      expect(chess.valid_and_occupied?(:a4)).to eql(false)
    end

    it "returns false" do
      expect(chess.valid_and_occupied?(:k4)).to eql(false)
    end

    it "returns false" do
      expect(chess.valid_and_occupied?(:d9)).to eql(false)
    end

    it "returns false" do
      expect(chess.valid_and_occupied?(:d32)).to eql(false)
    end

    it "returns true" do
      expect(chess.valid_and_occupied?(:a2)).to eql(true)
    end
  end

  describe "#valid_coord?" do
    it "returns false" do
      expect(chess.valid_coord?(:m5)).to eql(false)
    end

    it "returns false" do
      expect(chess.valid_coord?(:h0)).to eql(false)
    end

    it "returns false" do
      expect(chess.valid_coord?(:e10)).to eql(false)
    end

    it "returns true" do
      expect(chess.valid_coord?(:f5)).to eql(true)
    end
  end

end