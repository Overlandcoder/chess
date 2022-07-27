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
end
