require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Pawn do
  describe '#update_position' do
    subject(:pawn) { described_class.new(:white, 0) }
    let(:position) { instance_double(Coordinate, row: 6, col: 0) }
    let(:destination) { instance_double(Coordinate, row: 5, col: 0) }

    before do
      allow(pawn).to receive(:position).and_return(position)
      allow(pawn).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(5)
      pawn.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(0)
      pawn.update_position
    end
  end

  describe '#create_coordinate' do
    subject(:pawn) { described_class.new(:white, 1) }

    before do
      allow(pawn).to receive(:number).and_return(1)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 6, col: 1)
      pawn.create_coordinate
    end
  end

  describe '#generate_possible_moves' do
    context 'when the next square contains own piece' do
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/1P6/PP1PPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:pawn) { board.square_at(6, 1) }

      before do
        pawn.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(pawn.possible_moves.length).to eq(0)
      end
    end

    context 'when piece has made 0 moves from starting position' do
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:pawn) { board.square_at(1, 1) }

      before do
        pawn.instance_variable_set(:@moves_made, 0)
        pawn.generate_possible_moves(board)
      end

      it 'has 2 possible moves' do
        expect(pawn.possible_moves.sort).to eq([[2, 1], [3, 1]].sort)
      end
    end

    context 'when piece has made 1 move' do
      fen_string = 'rnbqkbnr/p1pppppp/1p6/8/8/8/PPPPPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:pawn) { board.square_at(2, 1) }

      before do
        pawn.update_position(2, 1)
        pawn.generate_possible_moves(board)
      end

      it 'has 1 possible move' do
        expect(pawn.possible_moves).to eq([[3, 1]].sort)
      end
    end

    context 'when a piece can be captured' do
      fen_string = 'rnbqkbnr/p1pppppp/1p6/2P5/8/8/PP1PPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:pawn) { board.square_at(2, 1) }

      before do
        pawn.update_position(2, 1)
        pawn.generate_possible_moves(board)
      end

      it 'can capture the piece or make a regular move' do
        expect(pawn.possible_moves.sort).to eq([[3, 1], [3, 2]].sort)
      end
    end

    context 'when path ahead blocked by opponent piece' do
      fen_string = 'rnbqkbnr/p1pppppp/8/1p6/1P6/8/PP1PPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:pawn) { board.square_at(4, 1) }

      before do
        pawn.update_position(4, 1)
        pawn.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(pawn.possible_moves.length).to eq(0)
      end
    end
  end
end
