require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/coordinate'

describe Rook do
  subject(:rook) { described_class.new(:white, 0, board) }

  let(:game) { instance_double(Game) }
  let(:board) { instance_double(Board) }

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
      let(:position) { instance_double(Coordinate, row: 4, col: 4) }

      it 'cannot move onto own piece one row up' do
        allow(board).to receive(:nil_or_opponent?).and_return(false)
        expect(rook.possible_moves.include?([3, 4])).to be false
        rook.generate_possible_moves
      end

      it 'cannot move onto own piece one column right' do
        allow(board).to receive(:nil_or_opponent?).and_return(false)
        expect(rook.possible_moves.include?([4, 5])).to be false
        rook.generate_possible_moves
      end

      it 'cannot move onto own piece one row down' do
        allow(board).to receive(:nil_or_opponent?).and_return(false)
        expect(rook.possible_moves.include?([5, 4])).to be false
        rook.generate_possible_moves
      end

      it 'cannot move onto own piece one column left' do
        allow(board).to receive(:nil_or_opponent?).and_return(false)
        expect(rook.possible_moves.include?([4, 3])).to be false
        rook.generate_possible_moves
      end
    end
  end
end
