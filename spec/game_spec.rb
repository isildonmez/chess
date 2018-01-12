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

  describe "#free_way" do
    context "when it is Knight" do
      it "returns true" do
        cur_piece = chess.board.get(:b1)
        expect(chess.free_way(:b1, :c3)).to eql(true)
      end
    end

    context "if any other piece" do
      it "returns false" do
        cur_piece = chess.board.get(:f8)
        expect(chess.free_way(:f8, :c5)).to eql(false)
      end

      it "returns true" do
        cur_piece = chess.board.get(:h7)
        expect(chess.free_way(:h7, :h5)).to eql(true)
      end
    end
  end

end