require_relative '../lib/rook'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/coordinate'

describe Rook do
  subject(:rook) { described_class.new('white', 0, board) }

  let(:game) { instance_double(Game) }
  let(:board) { instance_double(Board) }

  describe '#valid_path?' do
    context 'when direction is up and path is empty' do
      let(:destination) { instance_double(Coordinate, row: 4, col: 0) }

      before do
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(nil, nil, nil)
        allow(board).to receive(:opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.valid_path?).to be true
      end
    end

    context 'when direction is up and destination contains opponent piece' do
      let(:opponent_rook) { instance_double(described_class, color: 'black', number: 0, board: board) }
      let(:destination) { instance_double(Coordinate, row: 0, col: 0) }

      before do
        rook.instance_variable_set(:@row, 3)
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(nil, nil, opponent_rook)
        allow(board).to receive(:opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.valid_path?).to be true
      end
    end

    context 'when direction is down and path is empty' do
      let(:destination) { instance_double(Coordinate, row: 4, col: 0) }

      before do
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(nil, nil, nil, nil)
        allow(board).to receive(:opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.valid_path?).to be true
      end
    end

    context 'when direction is down and destination contains opponent piece' do
      subject(:rook) { described_class.new('black', 0, board) }

      let(:opponent_rook) { instance_double(described_class, color: 'white', number: 0, board: board) }
      let(:destination) { instance_double(Coordinate, row: 7, col: 0) }

      before do
        rook.instance_variable_set(:@row, 5)
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(nil, opponent_rook)
        allow(board).to receive(:opponent_piece?).and_return(true)
      end

      it 'returns true' do
        expect(rook.valid_path?).to be true
      end
    end

    context 'when direction is right and path is empty' do
      let(:destination) { instance_double(Coordinate, row: 7, col: 2) }

      before do
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(nil, nil)
        allow(board).to receive(:opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.valid_path?).to be true
      end
    end

    context 'when direction is left and destination contains opponent piece' do
      let(:opponent_rook) { instance_double(described_class, color: 'black', number: 0, board: board) }
      let(:destination) { instance_double(Coordinate, row: 7, col: 5) }

      before do
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(nil, nil)
        allow(board).to receive(:opponent_piece?).and_return(false)
      end

      it 'returns true' do
        expect(rook.valid_path?).to be true
      end
    end

    context 'when direction is right and path is not empty' do
      let(:opponent_rook) { instance_double(Rook, color: 'black', number: 0, board: board) }
      let(:destination) { instance_double(Coordinate, row: 7, col: 2) }

      before do
        rook.instance_variable_set(:@destination, destination)
        allow(board).to receive(:square_at).and_return(opponent_rook, opponent_rook)
        allow(board).to receive(:opponent_piece?).and_return(true)
      end

      it 'returns false' do
        expect(rook.valid_path?).to be false
      end
    end
  end

  describe '#change_position' do
    context 'when the move is valid' do
      xit 'sends #update_board to Board' do
        allow(rook).to receive(:valid_move?).and_return(true)
        expect(board).to receive(:update_board).with(4, 0, rook)
        rook.change_position([4, 0])
      end
    end
  end
end
