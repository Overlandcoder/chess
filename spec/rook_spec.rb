require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'

describe Rook do
  subject(:rook) { described_class.new('white', 0, board) }
  let(:game) { instance_double(Game) }
  let(:board) { instance_double(Board) }

  describe '#valid_path?' do
    context 'when direction is up and path is empty' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [4, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil)
        allow(board).to receive(:contains_opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.valid_path?('up')).to be true
      end
    end

    context 'when direction is up and destination contains opponent piece' do
      let(:opponent_rook) { instance_double(described_class, color: 'black', number: 0, board: board) }

      before do
        rook.instance_variable_set(:@position, [3, 0])
        rook.instance_variable_set(:@destination, [0, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil, opponent_rook)
        allow(board).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.valid_path?('up')).to be true
      end
    end

    context 'when direction is down and path is empty' do
      before do
        rook.instance_variable_set(:@position, [0, 0])
        rook.instance_variable_set(:@destination, [4, 0])
        allow(board).to receive(:square_at).and_return(nil, nil, nil, nil)
        allow(board).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.valid_path?('down')).to be true
      end
    end

    context 'when direction is down and destination contains opponent piece' do
      let(:opponent_rook) { instance_double(described_class, color: 'black', number: 0, board: board) }

      before do
        rook.instance_variable_set(:@position, [5, 0])
        rook.instance_variable_set(:@destination, [7, 0])
        allow(board).to receive(:square_at).and_return(nil, opponent_rook)
        allow(board).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.valid_path?('down')).to be true
      end
    end

    context 'when direction is right and path is empty' do
      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [7, 2])
        allow(board).to receive(:square_at).and_return(nil, nil)
        allow(board).to receive(:contains_opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.valid_path?('right')).to be true
      end
    end

    context 'when direction is left and destination contains opponent piece' do
      let(:opponent_rook) { instance_double(described_class, color: 'black', number: 0, board: board) }

      before do
        rook.instance_variable_set(:@position, [7, 7])
        rook.instance_variable_set(:@destination, [7, 5])
        allow(board).to receive(:square_at).and_return(nil, nil)
        allow(board).to receive(:contains_opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.valid_path?('left')).to be true
      end
    end

    context 'when direction is right and path is not empty' do
      let(:opponent_rook) { instance_double(Rook, color: 'black', number: 0, board: board) }

      before do
        rook.instance_variable_set(:@position, [7, 0])
        rook.instance_variable_set(:@destination, [7, 2])
        allow(board).to receive(:square_at).and_return(opponent_rook, opponent_rook)
        allow(board).to receive(:contains_opponent_piece?).and_return(true)
      end

      it 'returns false' do
        expect(rook.valid_path?('right')).to be false
      end
    end
  end

  describe '#valid_move?' do
    context 'when the move is valid' do
      it 'sends #within_board to Board' do
        expect(board).to receive(:within_board?)
        rook.valid_move?
      end
    end
  end
end
