require_relative '../lib/piece'
require_relative '../lib/king'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe King do
  describe '#update_position' do
    subject(:king) { described_class.new(:white, 0) }
    let(:position) { instance_double(Coordinate, row: 7, col: 4) }
    let(:destination) { instance_double(Coordinate, row: 6, col: 4) }

    before do
      allow(king).to receive(:position).and_return(position)
      allow(king).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(6)
      king.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(4)
      king.update_position
    end
  end

  describe '#create_coordinate' do
    subject(:king) { described_class.new(:white, 4) }

    before do
      allow(king).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 7, col: 4)
      king.create_coordinate
    end
  end

  describe '#generate_possible_moves' do
    context 'when surrounded by own pieces' do
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(7, 0) }

      before do
        king.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(king.possible_moves.length).to eq(0)
      end
    end

    context 'when an opponent one row up can be captured' do
      fen_string = 'r3k1n1/4rq2/8/2b5/2K1Q3/8/8/2B2BNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(4, 2) }

      before do
        king.update_position(4, 2)
        king.generate_possible_moves(board)
      end

      it 'can capture opponent piece' do
        expect(king.possible_moves).to include([3, 2])
      end

      it 'has 4 possible moves in this scenario' do
        expect(king.possible_moves.length).to eq(4)
      end
    end

    context 'when moving the king may lead to check' do
      fen_string = '4k1n1/4r3/8/2b5/r3Q3/3K4/1b5q/2B2BNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(5, 3) }

      before do
        king.update_position(5, 3)
        king.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(king.possible_moves.length).to eq(0)
      end
    end

    context 'when king is in check and moving to empty square is safe' do
      fen_string = '4k3/8/8/8/4Q3/1r1K4/3q4/2B2BNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(5, 3) }

      before do
        king.update_position(5, 3)
        king.generate_possible_moves(board)
      end

      it 'can move only move to squares one row above' do
        expect(king.possible_moves).to include([4, 2])
      end
    end

    context 'custom scenario' do
      fen_string = '4k1n1/4r3/5K2/2b5/r3Q3/8/1b5q/2B2BNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(2, 5) }

      before do
        king.update_position(2, 5)
        king.generate_possible_moves(board)
      end

      it 'has 3 possible moves in this scenario' do
        expect(king.possible_moves.length).to eq(3)
      end
    end

    context 'when capturing a piece would lead to check by opposing king' do
      fen_string = '4k3/4r3/5K2/2b5/r3Q3/8/1b5q/2B2BNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(2, 5) }

      before do
        king.update_position(2, 5)
        king.generate_possible_moves(board)
      end

      it 'cannot capture the piece because it would lead to check' do
        expect(king.possible_moves).not_to include([1, 4])
      end

      it 'has 3 possible moves in this scenario' do
        expect(king.possible_moves.length).to eq(3)
      end
    end

    context 'when king is in check by queen, and that queen is pinned to its king' do
      fen_string = '3K4/7N/r5B1/8/8/3qb3/2k5/8'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:king) { board.square_at(0, 3) }

      before do
        king.update_position(0, 3)
        king.generate_possible_moves(board)
      end

      it 'must escape check by moving to safe squares' do
        moves = [[0, 2], [1, 2], [0, 4], [1, 4]]
        expect(king.possible_moves.sort).to eq(moves.sort)
      end
    end
  end
end
