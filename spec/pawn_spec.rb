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
end
