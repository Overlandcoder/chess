require_relative '../lib/piece'
require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Rook do
  subject(:rook) { described_class.new(:white, 0) }

  let(:game) { instance_double(Game) }

  describe '#update_position' do
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

      it 'cannot move onto own piece one row up' do
        rook = board.square_at(7, 0)
        expect(rook.possible_moves.include?([6, 0])).to be false
        rook.generate_possible_moves(board)
      end

      it 'cannot move onto own piece one column right' do
        rook = board.square_at(7, 0)
        expect(rook.possible_moves.include?([7, 1])).to be false
        rook.generate_possible_moves(board)
      end

      it 'cannot move off the board one row down' do
        rook = board.square_at(7, 0)
        expect(rook.possible_moves.include?([8, 0])).to be false
        rook.generate_possible_moves(board)
      end
    end

    context ''
  end
end
