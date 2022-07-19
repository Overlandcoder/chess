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

    context '' do
      before do
        allow(rook).to receive(:position).and_return(position)
        allow(rook).to receive(:destination).and_return(destination)
        allow(position).to receive(:update_col)
      end

      it 'sends #update_row to Coordinate' do
        expect(position).to receive(:update_row).with(2)
        rook.update_position
      end
    end

    context '' do
      before do
        allow(rook).to receive(:position).and_return(position)
        allow(rook).to receive(:destination).and_return(destination)
        allow(position).to receive(:update_row)
      end

      it 'sends #update_col to Coordinate' do
        expect(position).to receive(:update_col).with(0)
        rook.update_position
      end
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
end
