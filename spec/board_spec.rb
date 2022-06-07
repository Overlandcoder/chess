require_relative '../lib/board'
require_relative '../lib/rook'

describe Board do
  subject(:board) { described_class.new }

  describe '#attach_piece' do
    let(:white_rook) { double(Rook, color: 'white', number: 0, board: board) }

    before do
      allow(white_rook).to receive(:position).and_return([7, 0])
    end

    it 'places the piece at the desired position' do
      board.attach_piece([white_rook])
      square = board.grid[7][0]
      expect(square).to eq(white_rook)
    end

    it 'does not attach a piece to other squares' do
      board.attach_piece([white_rook])
      square = board.grid[6][0]
      expect(square).to be nil
    end
  end

  describe '#square_at' do
    let(:black_rook) { double(Rook, color: 'black', number: 0, board: board) }

    before do
      allow(black_rook).to receive(:position).and_return([0, 0])
      board.attach_piece([black_rook])
    end

    it 'returns the correct object (piece)' do
      expect(board.square_at(0, 0)). to eq(black_rook)
    end

    it 'returns nil for an empty square' do
      expect(board.square_at(5, 0)). to be nil
    end
  end
end