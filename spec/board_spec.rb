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

  describe "#empty_between?" do

    context "when horizontal" do
      it "returns false" do
        expect(b.empty_between?(:a2, :c2)).to eql(false)
      end

      it "returns false" do
        expect(b.empty_between?(:f7, :b7)).to eql(false)
      end

      it "returns true" do
        expect(b.empty_between?(:h6, :g6)).to eql(true)
      end

      it "returns true" do
        expect(b.empty_between?(:d5, :f5)).to eql(true)
      end
    end

    context "when vertical" do
      it "returns false" do
        expect(b.empty_between?(:a2, :a8)).to eql(false)
      end

      it "returns false" do
        expect(b.empty_between?(:a8, :a2)).to eql(false)
      end

      it "returns true" do
        expect(b.empty_between?(:c7, :c6)).to eql(true)
      end

      it "returns true" do
        expect(b.empty_between?(:b2, :b5)).to eql(true)
      end
    end

    context "when forward diagonal" do
      it "returns false" do
        expect(b.empty_between?(:a1, :c3)).to eql(false)
      end

      it "returns false" do
        expect(b.empty_between?(:c3, :a1)).to eql(false)
      end

      it "returns true" do
        expect(b.empty_between?(:a1, :b2)).to eql(true)
        expect(b.empty_between?(:b2, :a1)).to eql(true)
        expect(b.empty_between?(:b2, :c3)).to eql(true)
        expect(b.empty_between?(:c3, :b2)).to eql(true)
      end

      it "returns true" do
        expect(b.empty_between?(:b2, :f6)).to eql(true)
      end
    end

    context "when backward diagonal" do
      it "returns false" do
        expect(b.empty_between?(:a4, :d1)).to eql(false)
      end

      it "returns false" do
        expect(b.empty_between?(:d1, :a4)).to eql(false)
      end

      it "returns true" do
        expect(b.empty_between?(:d1, :c2)).to eql(true)
        expect(b.empty_between?(:c2, :d1)).to eql(true)
        expect(b.empty_between?(:c2, :b3)).to eql(true)
        expect(b.empty_between?(:b3, :c2)).to eql(true)
      end

      it "returns true" do
        expect(b.empty_between?(:f2, :b6)).to eql(true)
      end
    end

  end




end