require_relative '../lib/piece'
require_relative '../lib/knight'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Knight do
  subject(:knight) { described_class.new(:white, 0) }

  describe '#create_coordinate' do
    it 'sends #new to Coordinate' do
      allow(knight).to receive(:number).and_return(0)
      expect(Coordinate).to receive(:new).with(row: 7, col: 1)
      knight.create_coordinate
    end
  end

  describe '#update_position' do
    let(:position) { instance_double(Coordinate, row: 7, col: 1) }
    let(:destination) { instance_double(Coordinate, row: 5, col: 2) }

    before do
      allow(knight).to receive(:position).and_return(position)
      allow(knight).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(5)
      knight.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(2)
      knight.update_position
    end
  end

  describe '#generate_possible_moves' do
    context 'when any move would place king in check' do
      fen_string = 'r1bq1bnr/pppp1ppp/4k3/4n3/8/4Q3/PPPPPPPP/RNB1KBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:knight) { board.square_at(3, 4) }

      before do
        knight.update_position(3, 4)
        knight.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(knight.possible_moves.length).to eq(0)
      end
    end

    context 'when king is in check and piece causing check must be captured' do
      fen_string = 'r1bq1bnr/pppp1ppp/4k3/4n3/6Q1/8/PPPPPPPP/RNB1KBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:knight) { board.square_at(3, 4) }

      before do
        knight.update_position(3, 4)
        knight.generate_possible_moves(board)
      end

      it 'can only move to capture the piece causing check' do
        expect(knight.possible_moves.flatten).to eq([4, 6])
      end
    end

    context 'when all possible move squares are empty' do
      fen_string = 'r1bqkbnr/pp5p/8/4n3/8/8/2PPPPP1/RNB1KBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:knight) { board.square_at(3, 4) }

      before do
        knight.update_position(3, 4)
        knight.generate_possible_moves(board)
      end

      it 'has a maximum of 8 possible moves' do
        expect(knight.possible_moves.length).to eq(8)
      end
    end

    context 'when king is in check and path to king can be blocked' do
      fen_string = 'r1bqkbnr/pp5p/3n2B1/8/8/8/2PPPPP1/RNB1K1NR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:knight) { board.square_at(2, 3) }

      before do
        knight.update_position(2, 3)
        knight.generate_possible_moves(board)
      end

      it 'can only move to block path to king and remove check' do
        expect(knight.possible_moves).to eq([[1, 5]])
      end
    end

    context 'when all possible move squares are occupied by own pieces' do
      fen_string = '2bqkb2/1p3p2/3n4/1n3p2/2r1r1B1/8/2PPPPP1/RNB1K1NR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:knight) { board.square_at(2, 3) }

      before do
        knight.update_position(2, 3)
        knight.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(knight.possible_moves.length).to eq(0)
      end
    end
  end
end
