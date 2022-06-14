require_relative '../lib/game'
require_relative '../lib/piece'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/coordinate'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { instance_double(Player, color: 'white') }
  let(:board) { instance_double(Board) }

  describe '#create_player' do
    before do
      allow(game).to receive(:puts)
    end

    it 'creates a new player with the right parameters' do
      color = 'white'
      expect(Player).to receive(:new).with(color)
      game.create_player('white')
    end
  end

  describe '#create_piece' do
    let(:rook) { instance_double(Rook, color: 'white', number: 0, board: board) }

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
        allow(game).to receive(:puts).with('Select a piece to move:')
      end

      it 'displays error message once' do
        error_message = "Please select your own piece!"
        expect(game).to receive(:puts).with(error_message).once
        game.choose_piece
      end
    end
  end

  describe '#choose_destination' do
    let(:rook) { instance_double(Rook, color: 'white', number: 0, board: board) }

    context 'when given an invalid move, then a valid move' do
      before do
        allow(game).to receive(:gets).and_return('A4')
        game.instance_variable_set(:@piece_to_move, rook)
        allow(rook).to receive(:set_destination)
        allow(rook).to receive(:valid_move?).and_return(false, true)
        allow(game).to receive(:puts).with('Enter the position to move the piece to:')
      end

      it 'stops loop and does not display error message' do
        error_message = 'Invalid move, please choose another square.'
        expect(game).to receive(:puts).with(error_message).once
        game.choose_destination
      end
    end
  end

  describe '#own_piece?' do
    before do
      allow(game).to receive(:board).and_return(board)
      allow(game).to receive(:current_player).and_return(player1)
    end

    it 'sends #opponent_piece? to Board' do
      expect(board).to receive(:opponent_piece?).with(7, 0, 'white')
      game.own_piece?(7, 0)
    end
  end

  describe '#remove_opponent_piece' do
    let(:rook) { instance_double(Rook, color: 'white', number: 0, board: board) }
    let(:player1) { instance_double(Player, color: 'white') }
    let(:coordinate) { instance_double(Coordinate, row: 7, col: 0) }

    before do
      allow(game).to receive(:opponent).and_return(player1)
      allow(board).to receive(:square_at).and_return(rook)
      allow(game).to receive(:board).and_return(board)
      allow(game).to receive(:destination).and_return(coordinate)
    end

    it 'sends #remove_piece to Player' do
      expect(player1).to receive(:remove_piece).with(rook)
      game.remove_opponent_piece
    end
  end

  describe '#update_board' do
    let(:rook) { instance_double(Rook, color: 'white', number: 0, board: board) }
    let(:destination) { instance_double(Coordinate, row: 0, col: 0) }

    before do
      allow(game).to receive(:destination).and_return(destination)
      allow(game).to receive(:board).and_return(board)
      allow(game).to receive(:piece_to_move).and_return(rook)
    end

    it 'sends #update_board to Board' do
      expect(board).to receive(:update_board).with(0, 0, rook)
      game.update_board
    end
  end

  describe '#update_piece_position' do
    let(:rook) { instance_double(Rook, color: 'white', number: 0, board: board) }

    before do
      allow(game).to receive(:piece_to_move).and_return(rook)
    end

    it 'sends #update_position to Rook' do
      expect(rook).to receive(:update_position)
      game.update_piece_position
    end
  end
end
