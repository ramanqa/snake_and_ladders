require 'yaml'

class SnakesAndLadders

  attr_accessor :board, :players, :turn

  def initialize board=YAML.load_file('./board.yaml')
    @board = board
    @players = Array.new
    @turn = 1
  end

  def player_join name
    player = Hash.new
    player['name'] = name
    player['position'] = 0
    player['id'] = @players.size + 1
    @players.push player
    @players
  end

  def player_update id, name
    @players.each do |player|
      if player['id'].to_i == id.to_i
        player['name'] = name.to_s
        return player
      end
    end
    raise "Non existent player with id '#{id}'"
  end

  def player_by_id id
    @players.each do |player|
      if player['id'].to_i == id.to_i
        return player
      end
    end
    raise "Non existent player with id '#{id}'"
  end

  def player_by_name name
    @players.each do |player|
      if(player['name'].to_s == name.to_s)
        return player
      end
    end
    raise "Non existent player with name '#{name}'"
  end

  def player_quit id
    error = true
    @players.each do |player|
      if player['id'].to_i == id.to_i
        error = false
        @players.delete player
        return player
      end
    end
    if(error)
      raise "Non existent player with id '#{id}'"
    end
  end

  def set_turn
    @turn += 1
    if @turn > @players.length
      @turn = 1
    end
  end

  def move player_id
    roll = rand 1..6
    error = true
    @players.each do |player|
      if(player['id'].to_i == player_id.to_i)
        if player['id'].to_i == @turn
          error = false
          initial_position = player['position'].to_i
          final_position = initial_position.to_i + roll.to_i
          if final_position>@board['end'].to_i
            final_position = initial_position
          else
            @board['snakes'].each do |position, target|
              if final_position.to_i == position.to_i
                final_position = target.to_i
              end
            end
            @board['ladders'].each do |position, target|
              if final_position.to_i == position.to_i
                final_position = target.to_i
              end
            end
          end
          player['position'] = final_position.to_i
          set_turn
        else
          raise "Invalid turn: Player id '#{player_id}' is trying to play out of turn"
        end
      end
    end
    if error
      raise "Non exitent player with id '#{player_id}"
    else
      return roll
    end
  end

  def print_board
    line = ""
    @board['end'].to_i.times do |column|
      position = column + 1
      snl = ""
      @board['snakes'].each do |pos,target|
        if(pos == position)
          snl = "|Snake:#{target}"
        end
      end        
      @board['ladders'].each do |pos,target|
        if(pos == position)
          snl = "|Ladder:#{target}"
        end
      end
      players = ""
      @players.each do |player|
        if player['position'].to_i == position
          players += " #{player['id']}:#{player['name']}"
        end
      end
      if players != ""
        players = "|Players:#{players}"
      end
      line += "[#{position}#{snl}#{players}]"
    end
    line.to_s
  end

end # class