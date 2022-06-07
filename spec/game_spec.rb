require_relative '../lib/game'
require_relative '../lib/piece'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { double(Player, name: 'a', color: 'white') }
  let(:board) { double(Board) }

  describe '#create_player' do
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return('John')
    end

    it 'creates a new player with the right parameters' do
      name = 'John'
      color = 'white'
      expect(Player).to receive(:new).with(name, color)
      game.create_player(1, 'white')
    end
  end

  describe '#create_piece' do
    let(:rook) { double(Rook, color: 'white', number: 0, board: board) }

    it 'sends .for to Piece' do
      allow(player1).to receive(:add_piece)
      expect(Piece).to receive(:for).with('rook', 'white', 0, board)
      game.create_piece('rook', 'white', player1, board, 0)
    end

    it 'sends #add_piece to Player' do
      allow(Piece).to receive(:for).and_return(rook)
      expect(player1).to receive(:add_piece).with(rook)
      game.create_piece('rook', 'white', player1, board, 0)
    end
  end
end