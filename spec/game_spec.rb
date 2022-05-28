require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

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
end