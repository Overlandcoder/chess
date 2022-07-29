require_relative '../lib/piece'
require_relative '../lib/bishop'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Bishop do
  subject(:bishop) { described_class.new(:white, 0) }

  describe '#create_coordinate' do
    let(:board) { instance_double(Board) }

    before do
      allow(bishop).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 7, col: 2)
      bishop.create_coordinate
    end
  end

  describe '#update_position' do
    let(:board) { instance_double(Board) }
    let(:position) { instance_double(Coordinate, row: 7, col: 2) }
    let(:destination) { instance_double(Coordinate, row: 5, col: 2) }

    before do
      allow(bishop).to receive(:position).and_return(position)
      allow(bishop).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(5)
      bishop.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(2)
      bishop.update_position
    end
  end

  describe '#generate_possible_moves' do
    context 'when surrounded by own pieces' do
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:bishop) { board.square_at(0, 5) }

      before do
        bishop.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(bishop.possible_moves.flatten.empty?).to be true
      end
    end

    context 'when path to opponent piece is empty' do
      fen_string = 'rnbqk1nr/pppppppp/8/6b1/8/8/PPPPPPPP/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:bishop) { board.square_at(3, 6) }

      before do
        bishop.generate_possible_moves(board)
      end

      it 'can capture opponent piece' do
        expect(bishop.possible_moves).to include([6, 3])
      end

      it 'can only make 6 possible moves' do
        expect(bishop.possible_moves.length).to eq(6)
      end

      it 'cannot move horizontally' do
        expect(bishop.possible_moves).not_to include([3, 5])
      end

      it 'cannot move vertically' do
        expect(bishop.possible_moves).not_to include([4, 6])
      end
    end

    context 'when king is in check and path to king can be blocked' do
      fen_string = 'rnbqk1nr/pppp1ppp/3p4/6b1/8/1PP5/PPP1QPPP/RNB1KBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:bishop) { board.square_at(3, 6) }

      before do
        bishop.update_position(3, 6)
        bishop.generate_possible_moves(board)
      end

      it 'can only move to the squares that remove check' do
        expect(bishop.possible_moves).to eq([[5, 4], [1, 4]])
      end
    end

    context 'when king is in check and opponent piece must be removed' do
      fen_string = 'rnbqk1nr/ppppQppp/3p4/6b1/8/1PP5/PPP2PPP/RNB1KBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:bishop) { board.square_at(3, 6) }

      before do
        bishop.update_position(3, 6)
        bishop.generate_possible_moves(board)
      end

      it 'can only move to capture opponent piece' do
        expect(bishop.possible_moves.flatten).to eq([1, 4])
      end
    end

    context 'when any move would put king in check' do
      fen_string = 'rnbq2nr/ppppp1pp/7k/8/7b/7R/PPPPPPP1/RNBQKBN1 w'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:bishop) { board.square_at(4, 7) }

      before do
        bishop.update_position(4, 7)
        bishop.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(bishop.possible_moves.empty?).to be true
      end
    end
  end
end
