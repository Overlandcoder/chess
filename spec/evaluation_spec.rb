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
end