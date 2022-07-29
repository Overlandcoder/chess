require_relative '../lib/piece'
require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Rook do
  describe '#update_position' do
    subject(:rook) { described_class.new(:white, 0) }
    let(:position) { instance_double(Coordinate, row: 7, col: 0) }
    let(:destination) { instance_double(Coordinate, row: 2, col: 0) }

    before do
      allow(rook).to receive(:position).and_return(position)
      allow(rook).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(2)
      rook.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(0)
      rook.update_position
    end
  end

  describe '#create_coordinate' do
    subject(:rook) { described_class.new(:white, 0) }

    before do
      allow(rook).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 7, col: 0)
      rook.create_coordinate
    end
  end

  describe '#generate_possible_moves' do
    context 'when the next square contains own piece' do
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:rook) { board.square_at(7, 0) }

      before do
        rook.generate_possible_moves(board)
      end

      it 'cannot move onto own piece one row up' do
        expect(rook.possible_moves).not_to include([6, 0])
      end

      it 'cannot move onto own piece one column right' do
        expect(rook.possible_moves).not_to include([7, 1])
      end
    end

    context 'when an upward vertical path to an opponent piece is clear' do
      fen_string = 'rnbqkbnr/pp1ppppp/8/8/p7/8/8/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:rook) { board.square_at(7, 0) }

      before do
        rook.generate_possible_moves(board)
      end

      it 'can capture opponent piece' do
        expect(rook.possible_moves).to include([4, 0])
      end

      it 'cannot jump to empty square past opponent piece' do
        expect(rook.possible_moves).not_to include([3, 0])
      end

      it 'cannot jump to opponent piece behind first opponent piece' do
        expect(rook.possible_moves).not_to include([0, 0])
      end

      it 'cannot move diagonally' do
        expect(rook.possible_moves).not_to include([6, 1])
      end

      it 'can move to an empty square on the path' do
        expect(rook.possible_moves).to include([5, 0])
      end
    end

    context 'when a leftward horizontal path to an opponent piece is clear' do
      fen_string = 'rnbqkbnr/pp1ppppp/8/8/1p1R4/8/8/1NBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:rook) { board.square_at(4, 3) }

      before do
        rook.update_position(4, 3)
        rook.generate_possible_moves(board)
      end

      it 'can capture opponent piece' do
        expect(rook.possible_moves).to include([4, 1])
      end

      it 'can move to an empty square on the path' do
        expect(rook.possible_moves).to include([4, 2])
      end
    end

    context 'when moving a piece may lead to check' do
      fen_string = 'rnb1kbnr/ppppqppp/8/8/1p2R3/8/8/1NBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:rook) { board.square_at(4, 4) }

      before do
        rook.update_position(4, 4)
        rook.generate_possible_moves(board)
      end

      it 'cannot make a move that would lead to check' do
        expect(rook.possible_moves).not_to include([4, 1])
      end

      it 'can capture opponent piece' do
        expect(rook.possible_moves).to include([1, 4])
      end
    end

    context 'when king is in check' do
      fen_string = 'rnb1kbnr/pppp1ppp/8/8/4R2q/5P2/PPPP2PP/RNBQKBN1 w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:rook) { board.square_at(4, 4) }

      before do
        rook.update_position(4, 4)
        rook.generate_possible_moves(board)
      end

      it 'can only move to capture the piece putting king in check' do
        expect(rook.possible_moves.flatten).to eq([4, 7])
      end
    end

    context 'when any move would put king in check' do
      fen_string = 'rnb1kbnr/pppp1ppp/8/8/7q/5PR1/PPPP2PP/RNBQKBN1 w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:rook) { board.square_at(5, 6) }

      before do
        rook.update_position(5, 6)
        rook.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(rook.possible_moves.flatten.empty?).to be true
      end
    end

    context 'when rook has king in check but king can escape' do
        fen_string = '4k3/8/8/8/4Q3/1r1K4/3q4/2B2BNR w'
        let(:board) { Fen.new.to_board(fen_string) }
        let(:rook) { board.square_at(5, 1) }
  
        before do
          rook.update_position(5, 1)
          rook.generate_possible_moves(board)
        end
  
        it 'cannot move to the safe square that king can escape to' do
          expect(rook.possible_moves).not_to include([4, 2])
        end
    end
  end
end
