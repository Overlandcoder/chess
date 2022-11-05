require_relative '../lib/piece'
require_relative '../lib/game'
require_relative '../lib/rook'
require_relative '../lib/bishop'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/coordinate'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { instance_double(Player, color: :white) }
  let(:board) { instance_double(Board) }

  describe '#create_players' do
    context 'check if white player is created properly' do
      before do
        allow(Player).to receive(:new).with(:black)
      end

      it 'creates white player with the right parameters' do
        color = :white
        expect(Player).to receive(:new).with(color)
        game.create_players
      end
    end

    context 'check if black player is created properly' do
      before do
        allow(Player).to receive(:new).with(:white)
      end

      it 'creates black player with the right parameters' do
        color = :black
        expect(Player).to receive(:new).with(color)
        game.create_players
      end
    end
  end

  describe '#choose_piece' do
    context 'when user chooses their own piece' do
      before do
        allow(game).to receive(:own_piece?).and_return(true)
        allow(game).to receive(:current_player).and_return(player1)
        allow(game).to receive(:gets).and_return('A1')
        allow(game).to receive(:board).and_return(board)
      end

      it 'does not display error message' do
        error_message = 'Please select your own piece!'
        expect(game).not_to receive(:puts).with(error_message)
        game.choose_piece
      end
    end

    context 'when the user chooses opponent piece, then their own piece' do
      before do
        allow(game).to receive(:own_piece?).and_return(false, true)
        allow(game).to receive(:current_player).and_return(player1)
        allow(game).to receive(:gets).and_return('H8', 'A1')
        allow(game).to receive(:board).and_return(board)
        allowed_message = "White, select a piece to move (enter 'retry' to reselect or 'save' to save):"
        allow(game).to receive(:puts).with(allowed_message)
      end

      it 'displays error message once' do
        error_message = "Please select your own piece!"
        expect(game).to receive(:puts).with(error_message).once
        game.choose_piece
      end
    end
  end

  describe '#choose_destination' do
    let(:rook) { instance_double(Rook, color: :white, number: 0) }

    context 'when given a valid move' do
      before do
        game.instance_variable_set(:@chosen_piece, rook)
        allow(rook).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:puts).with('Enter the position to move the piece to:')
        allow(game).to receive(:gets).and_return('a8')
        allow(rook).to receive(:destination=)
      end

      it 'stops loop and does not display error message' do
        error_message = 'Invalid move, please choose another square:'
        expect(game).not_to receive(:puts).with(error_message)
        game.choose_destination
      end

      it 'sends #new to Coordinate' do
        expect(Coordinate).to receive(:new).with(row: 0, col: 0)
        game.choose_destination
      end
    end

    context 'when given two invalid moves, then a valid move' do
      before do
        game.instance_variable_set(:@chosen_piece, rook)
        allow(rook).to receive(:valid_move?).and_return(false, false, true)
        allow(game).to receive(:gets).and_return('a2')
        allow(rook).to receive(:destination=)
      end

      it 'sends #new to Coordinate' do
        allow(game).to receive(:puts)
        expect(Coordinate).to receive(:new).with(row: 6, col: 0).exactly(3).times
        game.choose_destination
      end

      it 'displays error message twice' do
        allow(game).to receive(:puts).with('Enter the position to move the piece to:')
        error_message = 'Invalid move, please choose another square:'
        expect(game).to receive(:puts).with(error_message).twice
        game.choose_destination
      end
    end
  end

  describe '#own_piece?' do
    let(:rook) { instance_double(Rook, color: :white, number: 0) }
    let(:coordinate) { instance_double(Coordinate, row: 7, col: 0) }

    before do
      allow(game).to receive(:board).and_return(board)
      allow(game).to receive(:current_player).and_return(player1)
      allow(board).to receive(:place).with(coordinate, rook)
    end

    it 'sends #square_at to Board' do
      expect(board).to receive(:square_at).with(7, 0)
      game.own_piece?(7, 0)
    end
  end

  describe '#update_board' do
    let(:bishop) { instance_double(Bishop, color: :black, number: 1) }
    let(:board) { instance_double(Board) }
    let(:destination) { instance_double(Coordinate, row: 5, col: 0) }

    before do
      allow(game).to receive(:chosen_piece).and_return(bishop)
      allow(game).to receive(:destination).and_return(destination)
      allow(game).to receive(:board).and_return(board)
    end

    it 'sends #place to Board' do
      expect(board).to receive(:place).with(destination, bishop)
      game.update_board
    end
  end

  describe '#update_piece_position' do
    let(:rook) { instance_double(Rook, color: :white, number: 0) }

    before do
      allow(game).to receive(:chosen_piece).and_return(rook)
    end

    it 'sends #update_position to Rook' do
      expect(rook).to receive(:update_position)
      game.update_piece_position
    end
  end
end
