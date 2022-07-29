require_relative '../lib/evaluation'
require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/coordinate'
require_relative '../lib/kingside_castle'
require_relative '../lib/queenside_castle'
require_relative '../lib/fen'

describe Evaluation do
  describe '#stalemate?' do
    fen_string = '4k1n1/3bpppp/4q3/2K5/4r3/8/8/8 w'
    let(:board) { Fen.new.to_board(fen_string) }
    subject(:evaluation) { described_class.new(board, :white) }

    it 'results in stalemate' do
      expect(evaluation.stalemate?).to be true
    end
  end

  describe '#checkmate?' do
    context 'when white king is in checkmate' do
      fen_string = 'rnb1kbnr/pppppppp/8/8/7q/4P3/PPPPP2P/RNBQKBNR w'
      let(:board) { Fen.new.to_board(fen_string) }
      subject(:evaluation) { described_class.new(board, :white) }

      it 'results in checkmate' do
        expect(evaluation.checkmate?).to be true
      end
    end

    context 'when black king is in checkmate' do
      fen_string = 'rn1qkbnr/ppppp2p/8/7Q/8/4P3/PPPPP2P/RNB1KBNR b'
      let(:board) { Fen.new.to_board(fen_string) }
      subject(:evaluation) { described_class.new(board, :black) }

      it 'results in checkmate' do
        expect(evaluation.checkmate?).to be true
      end
    end
  end
end