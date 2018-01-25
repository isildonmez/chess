require_relative '../lib/board'
require_relative '../lib/pieces'

describe Board do
  subject(:b) { Board.new }

  describe "#initialize" do
    it "sets the board hash" do
      expect(b.board[:a7].nil?).to eql(false)
      expect(b.board[:a3].nil?).to eql(true)
    end
  end

  describe "#create_teams" do
    it "sets white_pieces and black_pieces hash" do
      expect(b.white_pieces.keys.all?{|obj| obj.colour == :white}).to eql(true)
      expect(b.black_pieces.length).to eql(16)
    end
  end

  describe "#sym" do
    it "returns coloured symbol" do
      expect(b.sym(:d2)).to eql("\e[97m♟")
      expect(b.sym(:d7)).to eql("\e[30m♟")
    end

    it "returns 1 space string" do
      expect(b.sym(:b5)).to eql(" ")
    end
  end

  describe "#update" do
    it "updates board" do
      expect(b.board[:a4]).to eql(nil)
      a_pawn = b.board[:a2]
      b.update(:a2, :a4, 3)
      expect(b.board[:a2]).to eql(nil)
      expect(b.board[:a4]).to eql(a_pawn)
    end

    it "changes teams hash" do
      expect(b.white_pieces.key(:h1).is_a? Rook).to eql(true)
      expect(b.black_pieces.key(:h8).is_a? Rook).to eql(true)
      expect(b.black_pieces.has_value?(:h1)).to eql(false)
      b.update(:h8, :h1, 42)
      expect(b.white_pieces.has_value?(:h1)).to eql(false)
      expect(b.black_pieces.key(:h1).is_a? Rook).to eql(true)
    end

    context "if en_passant?" do
      it "changes board and pieces hash" do
        b.board[:b4] = Pawn.new(:black)
        b.board[:c4] = Pawn.new(:white)
        b.board[:c4].turn_of_first_double_square = 10
        b.update(:b4, :c3, 11)
        expect(b.board[:c4]).to eql(nil)
        expect(b.white_pieces.has_value?(:c4)).to eql(false)
      end
    end
  end

  describe "#get_all_about_king" do
    it "returns King object" do
      expect(b.get_all_about_king(:white).is_a? Array).to eql(true)
      expect(b.get_all_about_king(:white).first.is_a? King).to eql(true)
    end
  end

  describe "#en_passant?" do
    it "returns true" do
      b.board[:b4] = Pawn.new(:black)
      b.board[:c4] = Pawn.new(:white)
      b.board[:c4].turn_of_first_double_square = 10
      expect(b.en_passant?(:b4, :c3, 11)).to eql(true)
    end

    it "returns false" do
      b.board[:e5] = Pawn.new(:white)
      b.board[:f5] = Pawn.new(:black)
      b.board[:f5].turn_of_first_double_square = 2
      expect(b.en_passant?(:e5, :d6, 4)).to eql(false)
    end
  end

  describe "#opponent_coord" do
    context "if black pawn" do
      it "returns opp_coord" do
        b.board[:b4] = Pawn.new(:black)
        expect(b.opponent_coord(:b4, :c3)).to eql(:c4)
      end
    end

    context "if white pawn" do
      it "returns opp_coord" do
        b.board[:h5] = Pawn.new(:white)
        expect(b.opponent_coord(:h5, :g6)).to eql(:g5)
      end
    end
  end

  describe "#castling?" do
    context "with a rook moved before" do
      it "returns false" do
        b.board[:a8] = Rook.new(:black, false)
        b.board[:e8] = King.new(:black, true)
        expect(b.castling?(:e8, :c8)).to eql(false)
      end
    end

    context "with a king moved before" do
      it "returns false" do
        b.board[:h8] = Rook.new(:black)
        b.board[:e8] = King.new(:black, false)
        expect(b.castling?(:e8, :g8)).to eql(false)
      end
    end

    context "without a rook" do
      it "returns false" do
        b.board[:a1] = nil
        b.board[:e1] = King.new(:white)
        expect(b.castling?(:e1, :c1)).to eql(false)
      end
    end

    context "after pawn_promotion of opponent" do
      it "return false" do
        b.board[:h1] = Rook.new(:black, true)
        b.board[:e1] = King.new(:white, true)
        expect(b.castling?(:e1, :g1)).to eql(false)
      end
    end

    context "if the board between king and rook is not empty" do
      it "returns false" do
        b.board[:h1] = Rook.new(:white, true)
        b.board[:e1] = King.new(:white, true)
        b.board[:g1] = Bishop.new(:white)
        expect(b.castling?(:e1, :h1)).to eql(false)
      end
    end

    context "if king is checked" do
      it "returns false" do
        b.board[:h3] = Rook.new(:white, true)
        b.board[:e3] = King.new(:white, true)
        b.board[:e3].is_checked = true
        expect(b.castling?(:e3, :g3)).to eql(false)
      end
    end

    it "returns true" do
      b.board[:h1] = Rook.new(:white, true)
      b.board[:e1] = King.new(:white, true)
      b.board[:f1] = nil
      b.board[:g1] = nil
      expect(b.castling?(:e1, :g1)).to eql(true)
    end
  end

  describe "#update_rook_after_castling" do
    context "left side" do
      it "returns rook's new coord" do
        b.board[:b8] = nil
        b.board[:c8] = nil
        b.board[:d8] = nil
        expect(b.update_rook_after_castling(:c8)).to eql(:d8)
        expect(b.black_pieces.has_value?(:a8)).to eql(false)
        expect(b.black_pieces.key(:d8).is_a? Rook).to eql(true)
        expect(b.board[:d8].is_a? Rook).to eql(true)
        expect(b.board[:a8].nil?).to eql(true)
        expect(b.board[:d8].never_moved).to eql(false)
      end
    end

    context "right side" do
      it "returns rook's new coord" do
        b.board[:f1] = nil
        b.board[:g1] = nil
        expect(b.update_rook_after_castling(:g1)).to eql(:f1)
        expect(b.white_pieces.has_value?(:h1)).to eql(false)
        expect(b.white_pieces.key(:f1).is_a? Rook).to eql(true)
        expect(b.board[:f1].is_a? Rook).to eql(true)
        expect(b.board[:h1].nil?).to eql(true)
        expect(b.board[:f1].never_moved).to eql(false)
      end
    end
  end

  describe "#pawn_promotion" do
    it "returns white Queen" do
      b.board[:a7] = Pawn.new(:white)
      b.pawn_promotion(:a7, :a8, "Queen")
      expect(b.board[:a8].is_a? Queen).to eql(true)
      expect(b.board[:a8].colour).to eql(:white)
      expect(b.white_pieces.has_value?(:a7)).to eql(false)
      expect(b.white_pieces.key(:a8).is_a? Queen).to eql(true)
    end
  end

  describe "#empty_path?" do
  end

  describe "#path_between" do
  end

  describe "#horizontal" do
    it "returns array" do
      expect(b.horizontal(:a2, :c2)).to eql([:b2])
      expect(b.horizontal(:f7, :b7)).to eql([:c7, :d7, :e7])
    end

    it "returns empty array" do
      expect(b.horizontal(:h6, :g6)).to eql([])
    end

    it "returns nil" do
      expect(b.horizontal(:d5, :f4)).to eql(nil)
      expect(b.horizontal(:d5, :d4)).to eql(nil)
    end
  end

  # describe "#{vertical}" do
  #   it "returns false" do
  #     expect(b.empty_between?(:a2, :a8)).to eql(false)
  #   end

  #   it "returns false" do
  #     expect(b.empty_between?(:a8, :a2)).to eql(false)
  #   end

  #   it "returns true" do
  #     expect(b.empty_between?(:c7, :c6)).to eql(true)
  #   end

  #   it "returns true" do
  #     expect(b.empty_between?(:b2, :b5)).to eql(true)
  #   end
  # end

  # describe "#{forward_diagonal}" do
  #   it "returns false" do
  #     expect(b.empty_between?(:a1, :c3)).to eql(false)
  #   end

  #   it "returns false" do
  #     expect(b.empty_between?(:c3, :a1)).to eql(false)
  #   end

  #   it "returns true" do
  #     expect(b.empty_between?(:a1, :b2)).to eql(true)
  #     expect(b.empty_between?(:b2, :a1)).to eql(true)
  #     expect(b.empty_between?(:b2, :c3)).to eql(true)
  #     expect(b.empty_between?(:c3, :b2)).to eql(true)
  #   end

  #   it "returns true" do
  #     expect(b.empty_between?(:b2, :f6)).to eql(true)
  #   end
  # end

  # describe "#{backward_diagonal}" do
  #   it "returns false" do
  #     expect(b.empty_between?(:a4, :d1)).to eql(false)
  #   end

  #   it "returns false" do
  #     expect(b.empty_between?(:d1, :a4)).to eql(false)
  #   end

  #   it "returns true" do
  #     expect(b.empty_between?(:d1, :c2)).to eql(true)
  #     expect(b.empty_between?(:c2, :d1)).to eql(true)
  #     expect(b.empty_between?(:c2, :b3)).to eql(true)
  #     expect(b.empty_between?(:b3, :c2)).to eql(true)
  #   end

  #   it "returns true" do
  #     expect(b.empty_between?(:f2, :b6)).to eql(true)
  #   end
  # end

  #   context "Anything else" do
  #     it "returns false" do
  #       expect(b.empty_between?(:d3, :h6)).to eql(false)
  #     end
  #   end




end