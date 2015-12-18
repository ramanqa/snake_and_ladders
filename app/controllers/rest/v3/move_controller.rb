module Rest
module V3

class MoveController < ApplicationController
  include ApplicationHelper

  skip_before_filter :verify_authenticity_token 
  before_action :doorkeeper_authorize!

  def show
    expires_now
    board = Board.find_by_id params[:id]    
    response = Hash.new
    if board
      player = board.players.find_by_id params[:player_id]
      if player
        turn_player = board.players.all[board.turn-1]
        if turn_player.id == player.id
          roll = move board.id, player.id
          response['board'] = display_board board.id
          response['roll'] = roll
          response['player'] = Player.select(:id, :name, :board_id, :position).find_by_id(player.id)
          response = response_hash 1, response, request.format.symbol
        else
          response = response_hash -1, "Invalid turn for player id", request.format.symbol  
        end
      else
        response = response_hash -1, "Invalid player id", request.format.symbol  
      end
    else
      response = response_hash -1, "Invalid board id", request.format.symbol
    end
    render request.format.symbol => response
  end
end

end
end