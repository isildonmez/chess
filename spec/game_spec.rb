require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:chess) { Game.new(Board.new) }


  describe "#check_cur_coord" do
    it "returns nil" do
      expect(chess.check_cur_coord(:a4)).to eql(nil)
    end

    it "returns false" do
      expect(chess.check_cur_coord(:k4)).to eql(false)
    end

    it "returns false" do
      expect(chess.check_cur_coord(:d9)).to eql(false)
    end

    it "returns false" do
      expect(chess.check_cur_coord(:d32)).to eql(false)
    end

    it "returns true" do
      expect(chess.check_cur_coord(:a2)).to eql(true)
    end
  end

end