require_relative '../lib/piece'
require_relative '../lib/queen'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Queen do
  describe '#update_position' do
    subject(:queen) { described_class.new(:white, 0) }
    let(:position) { instance_double(Coordinate, row: 7, col: 0) }
    let(:destination) { instance_double(Coordinate, row: 2, col: 0) }

    before do
      allow(queen).to receive(:position).and_return(position)
      allow(queen).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(2)
      queen.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(0)
      queen.update_position
    end
  end

  describe '#create_coordinate' do
    subject(:queen) { described_class.new(:white, 0) }

    before do
      allow(queen).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 7, col: 3)
      queen.create_coordinate
    end
  end
end
