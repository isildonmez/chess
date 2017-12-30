require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:chess) { Game.new(Board.new) }


  describe "#check_cur_coord" do
    it "returns :occupied" do
      expect(chess.check_cur_coord(:a4)).to eql(:occupied)
    end

    it "returns :invalid" do
      expect(chess.check_cur_coord(:k4)).to eql(:invalid)
    end

    it "returns :invalid" do
      expect(chess.check_cur_coord(:d9)).to eql(:invalid)
    end

    it "returns :invalid" do
      expect(chess.check_cur_coord(:d32)).to eql(:invalid)
    end

    it "returns :valid" do
      expect(chess.check_cur_coord(:a2)).to eql(:valid)
    end
  end

  describe "#check_new_coord" do
    it "returns :invalid" do
      expect(chess.check_new_coord(:m5)).to eql(:invalid)
    end

    it "returns :invalid" do
      expect(chess.check_new_coord(:h0)).to eql(:invalid)
    end

    it "returns :invalid" do
      expect(chess.check_new_coord(:e10)).to eql(:invalid)
    end

    it "returns :valid" do
      expect(chess.check_new_coord(:f5)).to eql(:valid)
    end
  end

end