require_relative '../lib/bishop'
require_relative '../lib/game'
require_relative '../lib/coordinate'

describe Bishop do
  subject(:bishop) { described_class.new(:white, 0, board) }

  let(:game) { instance_double(Game) }
  let(:board) { instance_double(Board) }

  describe '#create_coordinate' do
    before do
      allow(bishop).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 7, col: 2)
      bishop.create_coordinate
    end
  end
end
