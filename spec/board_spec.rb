require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/rook'
require_relative '../lib/coordinate'

describe Board do
  subject(:board) { described_class.new }
  describe '#place' do
    let(:rook) { instance_double(Rook) }
    let(:coordinate) { instance_double(Coordinate, row: 4, col: 0) }

    context 'when placing a piece on an empty square' do
      it 'updates the square from nil to the chosen piece' do
        expect { board.place(coordinate, rook) }.to change { board.square_at(4, 0) }.from(nil).to(rook)
      end
    end
  end
end