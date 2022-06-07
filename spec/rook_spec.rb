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
        allow(board).to receive(:within_board?).and_return(true)
        allow(board).to receive(:square_at)
      end

      it 'returns true' do
        expect(rook.valid_move?).to be true
      end
    end

    context 'when path is not empty' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [0, 0])
        allow(board).to receive(:within_board?).and_return(true)
        allow(board).to receive(:square_at).and_return(nil, nil, nil, nil, nil, nil, rook)
      end

      it 'returns false' do
        expect(rook.valid_move?).to be false
      end
    end

    context 'when given a diagonal (invalid) move as input' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [0, 7])
        allow(board).to receive(:within_board?).and_return(true)
        allow(rook).to receive(:path_empty?).and_return(true)
      end

      it 'returns false' do
        expect(rook.valid_move?).to be false
      end
    end
  end

  describe '#vertical' do
    context 'when direction is up and path is empty' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [4, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil)
        allow(game).to receive(:contains_opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.vertical('up')).to be true
      end
    end

    context 'when direction is up and destination contains opponent piece' do
      let(:opponent_rook) { double(Rook, color: 'black', number: 0, board: board) }
      
      before do
        rook.instance_variable_set(:@position, [3, 0])
        rook.instance_variable_set(:@destination, [0, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil, opponent_rook)
        allow(game).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.vertical('up')).to be true
      end
    end

    context 'when direction is down and path is empty' do
      before do
        rook.instance_variable_set(:@position, [0, 0])
        rook.instance_variable_set(:@destination, [4, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil, nil)
        allow(game).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.vertical('down')).to be true
      end
    end

    context 'when direction is down and destination contains opponent piece' do
      let(:opponent_rook) { double(Rook, color: 'black', number: 0, board: board) }
      
      before do
        rook.instance_variable_set(:@position, [5, 0])
        rook.instance_variable_set(:@destination, [7, 0])
        allow(board).to receive(:square_at).and_return(nil, opponent_rook)
        allow(game).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.vertical('down')).to be true
      end
    end
  end
end