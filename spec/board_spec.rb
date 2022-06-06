require_relative '../lib/board'
require_relative '../lib/rook'

describe Board do
  subject(:board) { described_class.new }
  let(:rook) { double(Rook, color: 'white', number: 0, board: board) }

  describe '#attach_piece' do
    before do
      allow(rook).to receive(:position).and_return([7, 0])
    end

    it 'places the piece at the desired position' do
      board.attach_piece([rook])
      square = board.grid[7][0]
      expect(square).to eq(rook)
    end

    it 'does not attach a piece to other squares' do
      board.attach_piece([rook])
      square = board.grid[6][0]
      expect(square).to be nil
    end
  end
end