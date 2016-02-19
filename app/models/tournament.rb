class Tournament < ActiveRecord::Base
  has_many :users, :through => :tournament_users
  has_many :matches
  has_many :tournament_users
  attr_accessor :rounds
  attr_accessor :current_round
  attr_accessor :players
  attr_accessor :root_match
  attr_accessor :match_order
  attr_accessor :num_of_matches

  #Removes a player from the player_1 or player_2 slot and pushes them into a match in the previous round.  
  def split_match(match)
    if match.player2_id != nil and @rounds[@current_round] == @rounds.last
      match.children[0] = self.matches.create(round: @current_round.to_i + 1, player1_id: nil, player2_id: nil, children: [nil, nil])
      match.children[1] = self.matches.create(round: @current_round.to_i + 1, player1_id: match.player2_id, player2_id: @players.shift, children: [nil, nil])
      match.update_attributes(:player2_id => nil) 
      @rounds.push([])
      @rounds[-1].push(match.children[0])
      @rounds[-1].push(match.children[1])
    elsif match.player2_id != nil
      match.children[0] = self.matches.create(round: @current_round.to_i, player1_id: nil, player2_id: nil, children: [nil,nil])
      match.children[1] = self.matches.create(round: @current_round.to_i, player1_id: match.player2_id, player2_id: @players.shift, children: [nil,nil])
      @rounds[-1].push(match.children[0])
      @rounds[-1].push(match.children[1])
      match.update_attributes(:player2_id => nil) 
    elsif match.player2_id == nil and match.player1_id != nil   
      match.children[0].update_attributes(:player1_id => match.player1_id, :player2_id => @players.shift)
      match.update_attributes(:player1_id => nil)    
      match.update_attributes(:player2_id => nil)         
    end       
  end

  #Determines if a round has no more players in it, which prompts @current_round to be updated to the previous round.
  def round_empty?(round)   
    empty = true
    round.each do |match|
      if match.player1_id != nil
          empty = false
      end
    end
    return empty
  end

  #Creates an array of all players signed up for the tournament, and shifts them into a binary tree until the array is empty
  def add_matches()
    @players = self.tournament_users.map{|user| user.id}
    @match_order = @players.length - 1
    @rounds =[] 
    @current_round = 0
    @root_match = self.matches.create(round: @current_round.to_i, player1_id: @players.shift, player2_id: @players.shift, children: [nil, nil])
    @rounds.push([])
    @rounds[0].push(@root_match)
    until @players.empty?
        if round_empty?(@rounds[@current_round])
            @current_round +=1
        elsif round_empty?(@rounds[@current_round]) == false
            split_match(lowest_seed_match(@rounds[@current_round]))            
        end
    end
    
    assign_rounds(@rounds)

    create_remaining_matches(@rounds[@current_round])
    if self.matches.maximum("round") == 3
      @num_of_matches = 15
    end
    assign_match_order(@root_match, [])
  end

  #Finds the match in a round that has the lowest seeded player. 
  #Used to figure out which player to push down the tree into the previous round (if needed) 
  def lowest_seed_match(round)
    lowest_seed = -1
    lowest_match = nil
    round.each do |match|
      if match.player2_id != nil and self.tournament_users.find(match.player2_id).seed > lowest_seed
          lowest_match = match
          lowest_seed = self.tournament_users.find(match.player2_id).seed
      elsif match.player1_id == nil and match.player2_id == nil
          lowest_seed = lowest_seed
      elsif match.player2_id == nil and self.tournament_users.find(match.player1_id).seed > lowest_seed
          lowest_match = match
          lowest_seed = self.tournament_users.find(match.player1_id).seed
      end
    end
    return lowest_match
end

  #Loops through the rounds[] array and assigns the correct round number to the match objects.
  def assign_rounds(rounds)
    rounds.each_with_index do |round, index|
      round.each do |match|
        puts "#{match.children}"
        match.update_attributes(:round => index.to_s)
      end
    end
  end

  #uses a breadth first traversal to assign a hidden id # 
  #the hidden id is used to display the matches on the tournament show page in the correct order.
  def assign_match_order(match, matches_to_visit)
    if match != nil and match.children.any? and @num_of_matches != nil
      matches_to_visit.push(match.children[1])
      matches_to_visit.push(match.children[0])
      match.update_attributes(:number => @num_of_matches) 
      @num_of_matches -= 1
      assign_match_order(matches_to_visit.shift, matches_to_visit)
    else
      match.update_attributes(:number => @num_of_matches) 
      @num_of_matches -= 1
      assign_match_order(matches_to_visit.shift, matches_to_visit)
    end
  end

  def blank_match
    return self.matches.create(round: @current_round.to_i + 2, player1_id: nil, player2_id: nil, children: [nil, nil])
  end

  def create_remaining_matches(round)  
    round.each do |match|
      puts "HALLLLLLLLLLLLLLLLLO"
      puts match.children[0].inspect
      puts match.children[1].inspect
      if match.player1_id != nil and match.player2_id != nil
        match.children[0] = self.matches.create(round: @current_round.to_i + 1, player1_id: nil, player2_id: nil, children: [nil, nil])
        match.children[1] = self.matches.create(round: @current_round.to_i + 1, player1_id: nil, player2_id: nil, children: [nil, nil])
        puts "MATCH 111111111"
        puts match.children[0].inspect
      end
    end
  end

end
