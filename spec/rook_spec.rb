require_relative '../lib/piece'
require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Rook do
  let(:game) { instance_double(Game) }

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
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
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
      fen_string = 'rnbqkbnr/pp1ppppp/8/8/p7/8/8/RNBQKBNR'
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
      fen_string = 'rnbqkbnr/pp1ppppp/8/8/1p1R4/8/8/1NBQKBNR'
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
  end
end
