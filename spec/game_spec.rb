require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#create_player' do
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return('John')
    end

    it 'creates a new player' do
      name = 'John'
      expect(Player).to receive(:new).with(name)
      game.create_player(1)
    end
  end
end