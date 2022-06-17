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
end
