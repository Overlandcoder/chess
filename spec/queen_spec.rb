require_relative '../lib/piece'
require_relative '../lib/queen'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/fen'
require_relative '../lib/evaluation'

describe Queen do
  describe '#update_position' do
    subject(:queen) { described_class.new(:white, 0) }
    let(:position) { instance_double(Coordinate, row: 7, col: 0) }
    let(:destination) { instance_double(Coordinate, row: 2, col: 0) }

    before do
      allow(queen).to receive(:position).and_return(position)
      allow(queen).to receive(:destination).and_return(destination)
    end

    it 'sends #update_row to Coordinate' do
      allow(position).to receive(:update_col)
      expect(position).to receive(:update_row).with(2)
      queen.update_position
    end

    it 'sends #update_col to Coordinate' do
      allow(position).to receive(:update_row)
      expect(position).to receive(:update_col).with(0)
      queen.update_position
    end
  end

  describe '#create_coordinate' do
    subject(:queen) { described_class.new(:white, 0) }

    before do
      allow(queen).to receive(:number).and_return(0)
    end

    it 'sends #new to Coordinate' do
      expect(Coordinate).to receive(:new).with(row: 7, col: 3)
      queen.create_coordinate
    end
  end

  describe '#generate_possible_moves' do
    context 'when surrounded by own pieces' do
      fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:queen) { board.square_at(7, 3) }

      before do
        queen.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(queen.possible_moves.length).to eq(0)
      end
    end

    context 'when an upward vertical path to an opponent piece is clear' do
      fen_string = 'r1nqkbnr/pp1ppppp/2p5/8/2Q5/8/PPPPPPPP/RNB1KBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:queen) { board.square_at(4, 2) }

      before do
        queen.generate_possible_moves(board)
      end

      it 'can capture opponent piece' do
        expect(queen.possible_moves).to include([2, 2])
      end

      it 'cannot jump to empty square past opponent piece' do
        expect(queen.possible_moves).not_to include([1, 2])
      end

      it 'cannot jump to opponent piece behind first opponent piece' do
        expect(queen.possible_moves).not_to include([0, 2])
      end

      it 'can move to an empty square on the path' do
        expect(queen.possible_moves).to include([3, 2])
      end
    end

    context 'when a leftward horizontal path to an opponent piece is clear' do
      fen_string = 'rnbqkbnr/pp1ppppp/8/8/1p1R4/8/8/1NBQKBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:queen) { board.square_at(4, 3) }

      before do
        queen.update_position(4, 3)
        queen.generate_possible_moves(board)
      end

      it 'can capture opponent piece' do
        expect(queen.possible_moves).to include([4, 1])
      end

      it 'can move to an empty square on the path' do
        expect(queen.possible_moves).to include([4, 2])
      end
    end

    context 'when moving a piece may lead to check' do
      fen_string = 'rnb1kbnr/ppppqppp/8/8/1p2R3/8/8/1NBQKBNR'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:queen) { board.square_at(4, 4) }

      before do
        queen.update_position(4, 4)
        queen.generate_possible_moves(board)
      end

      it 'cannot make a move that would lead to check' do
        expect(queen.possible_moves).not_to include([4, 1])
      end

      it 'can capture opponent piece' do
        expect(queen.possible_moves).to include([1, 4])
      end
    end

    context 'when king is in check' do
      fen_string = 'rnb1kbnr/pppp1ppp/8/8/4R2q/5P2/PPPP2PP/RNBQKBN1'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:queen) { board.square_at(4, 4) }

      before do
        queen.update_position(4, 4)
        queen.generate_possible_moves(board)
      end

      it 'can only move to capture the piece putting king in check' do
        expect(queen.possible_moves.flatten).to eq([4, 7])
      end
    end

    context 'when any move would put king in check' do
      fen_string = 'rnb1kbnr/pppp1ppp/8/8/7q/5PR1/PPPP2PP/RNBQKBN1'
      let(:board) { Fen.new.to_board(fen_string) }
      let(:queen) { board.square_at(5, 6) }

      before do
        queen.update_position(5, 6)
        queen.generate_possible_moves(board)
      end

      it 'has no possible moves' do
        expect(queen.possible_moves.flatten.empty?).to be true
      end
    end
  end
end
