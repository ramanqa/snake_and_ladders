module ApplicationHelper

  def response_translator response, type
    if(type == :json)
      return response.to_json
    else(type == :xml)
      return Gyoku.xml JSON.parse response.to_json
    end
  end

  def response_hash code, message, type
    resp = Hash.new
    resp['response'] = Hash.new
    resp['response']['status'] = 1
    if(code < 0)
      resp['response']['status'] = code
      resp['response']['message'] = message
      return response_translator resp, type
    else
      message.each do |key, value|
        resp['response'][key] = value
      end
      # resp['response']['body'] = message
      return response_translator resp, type
    end
  end

  def parse_request request, type
    if(type == :json)
      return JSON.parse request
    else(type == :xml)
      return Hash.from_xml request.gsub("\n", "")
    end
  end


  def create_board id
    board = Array.new
    layout = YAML.load_file "./db/board.yaml"
    board.push({'endpoint'=>0, 'type'=> 'Blank', 'players'=>[]})
    layout['end'].times do |index|
      step = Hash.new
      step['endpoint'] = index+1
      step['type'] = "Blank"
      if layout['snakes'].has_key? index+1
        step['endpoint'] = layout['snakes'][index+1]
        step['type'] = "Snake"
      elsif layout['ladders'].has_key? index+1
        step['endpoint'] = layout['ladders'][index+1]
        step['type'] = "Ladder"
      end
      step['players'] = Array.new
      board[index+1] = step
    end
    File.write "./db/board_#{id}.yaml", board.to_yaml
    board
  end

  def display_board id
    board = YAML.load_file "./db/board_#{id}.yaml"
    board_print = ""
    board.each_with_index do |step, index|
      board_print += "[#{index}:#{step['endpoint']}, #{step['type']}, players:#{step['players']}] "
    end
    board_print
  end

  def delete_board id
    File.delete "./db/board_#{id}.yaml"
  end

  def move board_id, player_id
    board = YAML.load_file "./db/board_#{board_id}.yaml"
    roll = rand 1..6
    board_db = Board.find_by_id board_id
    player = Player.find_by_id player_id
    initial_pos = player.position
    if roll + initial_pos >= board.count
      # skip turn
    else
      position = board[initial_pos + roll]['endpoint']
      board[board[initial_pos + roll]['endpoint']]['players'].push player_id
      board[initial_pos]['players'].delete player_id
      player.position = position
      player.save
    end
    board_db.turn = board_db.turn+1
    if board_db.turn > board_db.players.count
      board_db.turn = 1
    end
    board_db.save
    File.write "./db/board_#{board_id}.yaml", board.to_yaml
    roll
  end

end
