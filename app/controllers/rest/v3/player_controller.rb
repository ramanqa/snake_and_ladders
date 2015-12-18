module Rest
module V3

class PlayerController < ApplicationController
  include ApplicationHelper

  skip_before_filter :verify_authenticity_token  
  before_action :doorkeeper_authorize!
  
  def show
    expires_now()
    player = Player.select(:id, :board_id, :name, :position).find(params[:id])
    response = Hash.new
    response['player'] = player
    response = response_hash 1, response, request.format.symbol
    render request.format.symbol => response
  end

  def create
    expires_now()
    request_body = parse_request request.body.read, request.format.symbol
    response = Hash.new
    if request_body['board'] != nil
      board = Board.find_by_id request_body['board']
      if board
        if board.players.find_by_name request_body['player']['name']
          response = response_hash -1, "Player already exists", request.format.symbol
        else
          player = board.players.new # {"name"=> request_body['player']['name'], "turn"=> 0}
          player.name = request_body['player']['name']
          player.position = 0
          player.save
          created_player = Player.select(:id, :board_id, :name, :position).find_by_id player.id
          response['player'] = created_player
          response = response_hash 1, response, request.format.symbol 
        end
      else
        response = response_hash -1, "Invalid board id", request.format.symbol
      end
    else
      response = response_hash -1, "Invalid board id", request.format.symbol
    end
    render request.format.symbol => response
  end

  def update
    expires_now()
    request_body = parse_request request.body.read, request.format.symbol
    response = Hash.new
    player = Player.find_by_id params[:id]
    if player
      if request_body['player']['name'] != nil
        player.name = request_body['player']['name']
        player.save
        created_player = Player.select(:id, :board_id, :name, :position).find_by_id player.id
        response['player'] = created_player
        response = response_hash 1, response, request.format.symbol 
      else
        response = response_hash -1, "Invalid player name in request", request.format.symbol
      end
    else
      response = response_hash -1, "Invalid player id", request.format.symbol
    end    
    render request.format.symbol => response
  end

  def destroy
    expires_now()
    status_code = 200
    begin
      player = Player.find params[:id]
      player.destroy
      response = response_hash 1, {:success=>"OK"}, request.format.symbol       
    rescue Exception => e
      status_code = 500
      response = response_hash -1, e.message, request.format.symbol
    end
    render status: status_code, request.format.symbol => response
  end

end

end
end