require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/coordinate'

describe Rook do
  subject(:rook) { described_class.new(:white, 0, board) }

  let(:game) { instance_double(Game) }
  let(:board) { instance_double(Board) }

  describe '#update_position' do
    context 'when direction is up' do
      let(:position) { instance_double(Coordinate, row: 7, col: 0) }
      let(:destination) { instance_double(Coordinate, row: 0, col: 0) }

      before do
        allow(rook).to receive(:position).and_return(position)
        allow(rook).to receive(:destination).and_return(destination)
        rook.instance_variable_set(:@direction, 'up')
      end

      it 'sends #update_row to Coordinate' do
        expect(position).to receive(:update_row).with(0)
        rook.update_position
      end
    end

    context 'when direction is up' do
      let(:position) { instance_double(Coordinate, row: 7, col: 0) }
      let(:destination) { instance_double(Coordinate, row: 0, col: 0) }

      before do
        allow(rook).to receive(:position).and_return(position)
        allow(rook).to receive(:destination).and_return(destination)
        rook.instance_variable_set(:@direction, 'up')
        allow(position).to receive(:update_row)
      end

      it 'sends #row to Coordinate' do
        expect(destination).to receive(:row)
        rook.update_position
      end
    end

    context 'when direction is right' do
      let(:position) { instance_double(Coordinate, row: 7, col: 0) }
      let(:destination) { instance_double(Coordinate, row: 7, col: 4) }

      before do
        allow(rook).to receive(:position).and_return(position)
        allow(rook).to receive(:destination).and_return(destination)
        rook.instance_variable_set(:@direction, 'right')
      end

      it 'sends #update_col to Coordinate' do
        expect(position).to receive(:update_col).with(4)
        rook.update_position
      end
    end

    context 'when direction is right' do
      let(:position) { instance_double(Coordinate, row: 7, col: 0) }
      let(:destination) { instance_double(Coordinate, row: 7, col: 5) }

      before do
        allow(rook).to receive(:position).and_return(position)
        allow(rook).to receive(:destination).and_return(destination)
        rook.instance_variable_set(:@direction, 'right')
        allow(position).to receive(:update_col)
      end

      it 'sends #col to Coordinate' do
        expect(destination).to receive(:col)
        rook.update_position
      end
    end
  end

  describe '#valid_move?' do
    let(:position) { instance_double(Coordinate, row: 7, col: 0) }
    let(:destination) { instance_double(Coordinate, row: 2, col: 0) }

    before do
      allow(rook).to receive(:position).and_return(position)
      allow(rook).to receive(:destination).and_return(destination)
      allow(rook).to receive(:valid_path?).and_return(true)
    end

    it 'sends #row to Coordinate' do
      expect(position).to receive(:row)
      rook.valid_move?
    end

    it 'sends #col to Coordinate' do
      expect(position).to receive(:col)
      rook.valid_move?
    end
  end

  describe '#destination_reached?' do
    context 'when direction is up' do
      let(:destination) { instance_double(Coordinate, row: 7, col: 0) }

      before do
        allow(rook).to receive(:destination).and_return(destination)
        allow(rook).to receive(:direction).and_return('up')
      end

      it 'sends #row to Coordinate' do
        expect(destination).to receive(:row)
        rook.destination_reached?
      end
    end

    context 'when direction is left' do
      let(:destination) { instance_double(Coordinate, row: 7, col: 7) }

      before do
        allow(rook).to receive(:destination).and_return(destination)
        allow(rook).to receive(:direction).and_return('left')
      end

      it 'sends #col to Coordinate' do
        expect(destination).to receive(:col)
        rook.destination_reached?
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
