require_relative '../lib/knight'
require_relative '../lib/game'
require_relative '../lib/coordinate'

describe Knight do
  subject(:knight) { described_class.new('white', 0, board) }

  let(:game) { instance_double(Game) }
  let(:board) { instance_double(Board) }

  describe '#create_coordinate' do
    before do
      allow(knight).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
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
end
