class Tournament < ActiveRecord::Base
	has_many :users, :through => :tournament_users
	has_many :matches
	has_many :tournament_users
    attr_accessor :rounds
    attr_accessor :current_round
    attr_accessor :players

	def split_match(match)
        if match.player2_id != nil and @rounds[$current_round] == @rounds.last
                new_match = self.matches.create(round: $current_round.to_i, player1_id: match.player2_id, player2_id: @players.shift)
                #match.children[1] = new_match
                @rounds.push([])
                @rounds[-1].push(new_match)
                match.update_attributes(:player2_id => nil)
        elsif match.player2_id != nil
                new_match = self.matches.create(round: $current_round.to_i, player1_id: match.player2_id, player2_id: @players.shift)
                #match.children[1] = new_match
                @rounds[-1].push(new_match)
                match.update_attributes(:player2_id => nil) 
        elsif match.player2_id == nil and match.player1_id != nil
                new_match = self.matches.create(round: $current_round.to_i, player1_id: match.player1_id, player2_id: @players.shift)
                #match.children[0] = new_match
                @rounds[-1].push(new_match)
                match.update_attributes(:player1_id => nil)             
        end       
    end

    def round_empty?(round)   
        empty = false
        round.each do |match|
            if match.player1_id == nil and @rounds[$current_round].last.player1_id == nil
                empty = true
            end
        end
        return empty
    end

    def add_matches()
        puts users
        x = 0
        @players = self.tournament_users.map{|user| user.id}
        @rounds =[] 
        $current_round = 0
        $root_match = self.matches.create(round: $current_round.to_i, player1_id: @players.shift, player2_id: @players.shift)
        @rounds.push([])
        @rounds[0].push($root_match)
        
        until @players.empty?
            if round_empty?(@rounds[$current_round]) == false
                split_match(lowest_seed_match(@rounds[$current_round])) 
            elsif round_empty?(@rounds[$current_round])
                $current_round +=1
            end
        end
        assign_rounds(@rounds)
        # @rounds.each do |round|
        #   round.each do |match|
        #     puts match.inspect
        #   end
        # end
    end

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

   def assign_rounds(rounds)
     rounds.each_with_index do |round, index|
        round.each do |match|
          match.update_attributes(:round => index.to_s)
        end
      end
   end


	
end
