module Soap

class V1Controller < ApplicationController
  include ApplicationHelper
  include WashOut::SOAP

  soap_service namespace: 'urn:SnakesAndLadders:v1'

  soap_action "createBoard",
        :return => {:newBoard => {:id=>:integer, :turn=>:integer, :layout=>:string}}
  def createBoard
    board = Board.new
    board.turn = 1
    board.save
    create_board board.id
    boardHash = Hash.new
    boardHash["id"] = board.id
    boardHash["turn"] = board.turn
    boardHash["layout"] = display_board board.id
    render :soap => {:newBoard => boardHash}
  end

  soap_action "getBoard",
        :args   => {:id => :integer},
        :return => {:board => {:id=>:integer, :turn=>:integer, :layout=>:string},
                     :boardPlayer => [{:id => :integer, :name => :string, :position => :integer}]
                    }
  def getBoard
    board = Board.find_by_id(params[:id])
    if board
      boardHash = Hash.new
      boardHash['id'] = board.id
      boardHash['turn'] = board.turn
      boardHash['layout'] = display_board board.id
      players = Array.new

      board.players.each do |pl|
        player = Hash.new
        player["id"] = pl.id
        player["name"] = pl.name
        player["position"] = pl.position
        players.push player
      end
      render :soap => {:board => boardHash, :boardPlayer => players}
    else
      raise SOAPError, "Invalid board id"
    end
  end

  soap_action "listBoards",
        :return => {:boards => [{:id=>:integer, :turn=>:integer, :layout=>:string}]}
  def listBoards
    boards = Array.new
    begin
      Board.all.each do |board_db|
        board = Hash.new
        board['id'] = board_db.id
        board['turn'] = board_db.turn
        board['layout'] = display_board board_db.id
        boards.push board
      end
    rescue Exception => e
      raise SOAPError, e.message
    end
    render :soap => {:boards => boards}
  end

  soap_action "resetBoard",
        :args   => {:id => :integer},
        :return => {:resetBoard => {:id=>:integer, :turn=>:integer, :layout=>:string}}
  def resetBoard
    board = Board.find_by_id params[:id]
    board.turn = 1
    board.save
    create_board board.id
    board.players.each do |player|
      player.destroy!
    end
    boardHash = Hash.new
    boardHash["id"] = board.id
    boardHash["turn"] = board.turn
    boardHash["layout"] = display_board board.id
    render :soap => {:resetBoard => boardHash}
  end

  soap_action "destroyBoard",
        :args   => {:id => :integer},
        :return => {:success => :string}
  def destroyBoard
    begin
      board = Board.find params[:id]
      board.players.each do |player|
        player.destroy
      end
      board.destroy
      delete_board params[:id]
    rescue Exception => e
      raise SOAPError, e.message
    end
    render :soap => {:success => "OK"}
  end

  soap_action "joinPlayer",
        :args   => {:board_id => :integer, :player_name=>:string},
        :return => {:joinedPlayer => {:id=>:integer, :name=>:string, :position=>:integer, :board_id=>:integer}}
  def joinPlayer
    board = Board.find_by_id params[:board_id]
    player = nil
    if board.players.find_by_name params['player_name']
      raise SOAPError, "Player already exists on board"
    else
      player = board.players.new
      player.name = params['player_name']
      player.position = 0
      player.save
    end
    joinedPlayer = Hash.new
    joinedPlayer["id"] = player.id
    joinedPlayer["board_id"] = player.board_id
    joinedPlayer["name"] = player.name
    joinedPlayer["position"] = player.position
    render :soap => {:joinedPlayer => joinedPlayer}
  end

  soap_action "getPlayer",
        :args   => {:id => :integer},
        :return => {:player => {:id=>:integer, :name=>:string, :position=>:integer, :board_id=>:integer}}
  def getPlayer
    foundPlayer = Hash.new
    begin
      player = Player.find params[:id]      
      foundPlayer['id'] = player.id
      foundPlayer['name'] = player.name
      foundPlayer['board_id'] = player.board_id
      foundPlayer['position'] = player.position
    rescue Exception => e
      raise SOAPError, e.message
    end
    render :soap => {:player => foundPlayer}
  end

  soap_action "updatePlayer",
        :args   => {:id => :integer, :name => :string},
        :return => {:updatedPlayer => {:id=>:integer, :name=>:string, :position=>:integer, :board_id=>:integer}}
  def updatePlayer
    foundPlayer = Hash.new
    begin
      player = Player.find params[:id]
      player.name = params[:name]
      player.save
      player = Player.find params[:id]
      foundPlayer['id'] = player.id
      foundPlayer['name'] = player.name
      foundPlayer['board_id'] = player.board_id
      foundPlayer['position'] = player.position
    rescue Exception => e
      raise SOAPError, e.message
    end
    render :soap => {:updatedPlayer => foundPlayer}
  end

  soap_action "quitPlayer",
        :args   => {:id => :integer},
        :return => {:success => :string}
  def quitPlayer
    foundPlayer = Hash.new
    begin
      player = Player.find params[:id]
      player.destroy
    rescue Exception => e
      raise SOAPError, e.message
    end
    render :soap => {:success => "OK"}
  end

  soap_action "playTurn",
        :args   => {:board_id => :integer, :player_id => :integer},
        :return => {:board_id=>:integer, :boardLayout=>:string, :roll=>:integer, :movedPlayer=>{:id=>:integer, :name=>:string, :position=>:integer}}
  def playTurn
    response = Hash.new
    begin
      board = Board.find params[:board_id]
      player = board.players.find params[:player_id]
      turn_player = board.players.all[board.turn-1]
      if turn_player.id == player.id        
        roll = move board.id, player.id
        response['board_id'] = board.id
        response['boardLayout'] = display_board board.id
        response['roll'] = roll
        movedPlayer = Player.select(:id, :name, :position).find_by_id(player.id)
        response['movedPlayer'] = {:id=>movedPlayer.id, :name=>movedPlayer.name, :position=>movedPlayer.position}
      else
        raise SOAPError, "Invalid turn for player id"
      end
    rescue Exception => e
      raise SOAPError, e.message
      p e.message
    end
    render :soap => response
  end
end # class
end # module