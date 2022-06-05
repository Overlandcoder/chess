require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'

describe Rook do
  subject(:rook) { described_class.new('white', 0, board) }
  let(:game) { double(Game) }
  let(:board) { double(Board) }

  describe '#valid_move?' do
    context 'when given a valid move as input' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [4, 0])
        allow(board).to receive(:square_at)
      end

      it 'returns true' do
        expect(rook.valid_move?).to be true
      end
    end

    context 'when given an invalid move as input' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [0, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil, nil, nil, nil, "\u001b[30m\u265C")
      end

      it 'returns false' do
        expect(rook.valid_move?).to be false
      end
    end
  end
end