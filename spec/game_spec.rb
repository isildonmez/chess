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

  describe "#its_king_checked?" do
    it "returns true" do
      chess.board.update(:d2, :d4, 8)
      chess.board.update(:a8, :a4, 9)
      chess.board.update(:e1, :e4, 10)
      expect(chess.its_king_checked?(:d4, :d5, 12)).to eql(true)
      expect(chess.board.get(:d4).is_a? Pawn).to eql(true)
      expect(chess.board.get(:d5).nil?).to eql(true)
      expect(chess.board.white_pieces.has_value?(:d5)).to eql(false)
      expect(chess.board.white_pieces.key(:d4).is_a? Pawn).to eql(true)
    end

    it "returns false" do
      chess.board.update(:d7, :d5, 8)
      chess.board.update(:a1, :a4, 9)
      chess.board.update(:e8, :e5, 10)
      expect(chess.its_king_checked?(:d5, :d4, 12)).to eql(false)
      expect(chess.board.get(:d5).is_a? Pawn).to eql(true)
      expect(chess.board.get(:d4).nil?).to eql(true)
      expect(chess.board.black_pieces.has_value?(:d4)).to eql(false)
      expect(chess.board.black_pieces.key(:d5).is_a? Pawn).to eql(true)
    end
  end

  describe "#checks_the_opponent_king?" do
    it "returns false" do
      chess.board.update(:e8, :e6, 23)
      chess.board.update(:c1, :c3, 24)
      expect(chess.checks_the_opponent_king?(:c3, 24)).to eql(false)
    end

    it "returns true" do
      chess.board.update(:e1, :e4, 17)
      chess.board.update(:g8, :f6, 18)
      expect(chess.checks_the_opponent_king?(:f6, 18)).to eql(true)
    end
  end

  describe "#king_can_move_to" do
    it "returns an array" do
      chess.board.update(:e1, :e4, 8)
      expect(chess.king_can_move_to(:white, 11)).to eql([:d3, :d4, :d5, :e3, :e5, :f3, :f4, :f5])
    end

    it "returns an array" do
      expect(chess.board.get(:f4).nil?).to eql(true)
      expect(chess.board.get(:f5).nil?).to eql(true)
      chess.board.update(:d7, :d6, 7)
      chess.board.update(:e1, :e4, 8)
      chess.board.update(:d8, :c3, 9)
      chess.board.update(:g8, :f6, 11)
      expect(chess.king_can_move_to(:white, 11)).to eql([:f4])
    end
  end

  describe "#piece_can_be_eaten" do
    it "returns true" do
      chess.board.update(:e1, :e3, 15)
      chess.board.update(:f7, :f4, 16)
      expect(chess.piece_can_be_eaten?(:black, 17)).to eql(true)
    end

    it "returns false" do
      chess.board.update(:d8, :d6, 14)
      chess.board.update(:e1, :e3, 15)
      chess.board.update(:d7, :d4, 16)
      expect(chess.piece_can_be_eaten?(:black, 17)).to eql(false)
    end
  end

  describe "#any_piece_can_move_between?" do
    it "returns true" do
      chess.board.update(:e1, :d3, 20)
      chess.board.update(:a1, :a5, 22)
      chess.board.update(:d7, :c6, 23)
      expect(chess.any_piece_can_move_between?(:black, 24)).to eql(true)
    end

    it "returns false" do
      chess.board.update(:e1, :e4, 3)
      chess.board.update(:g8, :f6, 4)
      expect(chess.any_piece_can_move_between?(:black, 5)).to eql(false)
    end

    it "returns false" do
      chess.board.update(:g8, :e5, 11)
      chess.board.update(:e1, :e3, 12)
      chess.board.update(:h8, :e6, 13)
      chess.board.update(:e3, :g4, 15)
      expect(chess.any_piece_can_move_between?(:black, 5)).to eql(false)
    end
  end

end