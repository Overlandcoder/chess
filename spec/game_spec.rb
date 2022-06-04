require_relative '../lib/game'
require_relative '../lib/piece'
require_relative '../lib/player'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { double(Player, name: 'a', color: 'white') }

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
    it 'sends .for to Piece' do
      allow(player1).to receive(:add_piece)
      expect(Piece).to receive(:for).with('rook', 'white', 0)
      game.create_piece('rook', 'white', player1, 0)
    end
  end
end