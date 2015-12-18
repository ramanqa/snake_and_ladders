module Rest
module V3
class BoardController < ApplicationController
  include ApplicationHelper

  skip_before_filter :verify_authenticity_token
  before_action :doorkeeper_authorize!

  def index
    expires_now()
    status_code = 200
    response = Hash.new
    begin
      boards = Array.new
      Board.all.each do |board_row|
        board = Hash.new
        board['id'] = board_row.id
        board['turn'] = board_row.turn
        board['layout'] = display_board board_row.id
        boards.push board
        response['board'] = boards
      end
      response = response_hash 1, response, request.format.symbol
    rescue Exception => e
      status_code = 500
      response = response_hash -1, e.message, request.format.symbol
    end
    render status: status_code, request.format.symbol => response
  end

  def show
    expires_now()
    board = Board.find_by_id params[:id]
    response = Hash.new
    if board
      response['board'] = Hash.new
      response['board']['layout'] = display_board board.id
      response['board']['id'] = board.id
      response['board']['turn'] = board.turn
      response['board']['players'] = Array.new
      board.players.each do |pl|
        player = Hash.new
        player['id'] = pl.id
        player['name'] = pl.name
        player['position'] = pl.position
        response['board']['players'].push player
      end
      response = response_hash 1, response, request.format.symbol
    else
      response = response_hash -1, "Invalid board id", request.format.symbol
    end
    render request.format.symbol => response
  end

  def new
    expires_now()
    board = Board.new
    board.turn = 1
    board.save
    create_board board.id
    response = Hash.new
    response['board'] = Hash.new
    response['board']['layout'] = display_board board.id
    response['board']['id'] = board.id
    response['board']['turn'] = board.turn
    response = response_hash 1, response, request.format.symbol
    render request.format.symbol => response
  end

  def update
    expires_now()
    board = Board.find_by_id params[:id]
    board.turn = 1
    board.save
    create_board board.id
    board.players.each do |player|
      player.destroy!
    end
    response = Hash.new
    response['board'] = Hash.new
    response['board']['layout'] = display_board board.id
    response['board']['id'] = board.id
    response['board']['turn'] = board.turn
    response = response_hash 1, response, request.format.symbol
    render request.format.symbol => response
  end

  def destroy    
    expires_now()
    status_code = 200
    response = nil
    begin
      board = Board.find params[:id]
      board.players.each do |player|
        player.destroy
      end
      board.destroy
      delete_board params[:id]
      response = response_hash 1, {:success=>"OK"}, request.format.symbol  
    rescue Exception => e
      status_code = 500
      response = response_hash -1, e.message, request.format.symbol
    end
    render status: status_code, request.format.symbol => response
  end

end # class
end # module
end