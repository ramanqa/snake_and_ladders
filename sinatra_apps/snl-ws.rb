require 'sinatra'
require 'sinatra-websocket'
require 'ostruct'

set :server, 'thin'
set :sockets, []

configure do
  set :boards, Hash.new
end

# $boards = Hash.new

get '/snl-ws/:board_id' do
  id = params[:board_id]
  if (settings.boards[id] == nil)
    settings.boards[id] = Array.new
  end
  if !request.websocket?
    status 400
    return "WS Only"
  else
    request.websocket do |ws|
      ws.onopen do
        # ws.send("WS Opened - #{params[:board_id]}")
        if !settings.boards[id].include?(ws)
          settings.boards[id].push ws
        end
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        EM.next_tick do 
          settings.boards[id].each do |s|
            s.send(msg)
          end
        end
      end
      ws.onclose do
        # warn("WS Closed - #{params[:board_id]}")
        settings.sockets.delete(ws)
      end
    end
  end
end

put '/snl-ws/:board_id' do
  board = request.body.read
  if settings.boards[params[:board_id]]
    settings.boards[params[:board_id]].each do |s|
      s.send board
    end
  end
  "OK"
end