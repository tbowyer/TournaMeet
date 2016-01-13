class Tournament < ActiveRecord::Base
	has_many :users, :through => :tournament_users
	has_many :matches
	has_many :tournament_users

	def split_match(match)
        if match.player_2 != nil and self.rounds[self.current_round] == self.rounds.last
                new_match = Match.new(match.player_2, self.players.shift, match, [nil, nil])
                match.children[1] = new_match
                self.rounds.push([])
                self.rounds[-1].push(new_match)
                match.player_2 = nil
        elsif match.player_2 != nil
                new_match = Match.new(match.player_2, self.players.shift, match, [nil, nil])
                match.children[1] = new_match
                self.rounds[-1].push(new_match)
                match.player_2 = nil
        elsif match.player_2 == nil and match.player_1 != nil
                new_match = Match.new(match.player_1, self.players.shift, match, [nil, nil])
                match.children[0] = new_match
                self.rounds[-1].push(new_match)
                match.player_1 = nil
        end       
    end

    def round_empty?(round)   
        empty = false
        round.each do |match|
            if match.player1_id == nil and @rounds[@current_round].last.player1_id == nil
                empty = true
            end
        end
        return empty
    end

    def add_matches()
        x = 0
        @players = self.users
        @rounds = []
        current_node = self.matches.create(round: nil, player1_id: @players.shift, player2_id: @players.shift)
        @rounds.push([])
        @rounds[0].push(current_node)
       	@current_round = 0
        
        until @players.empty?
            if round_empty?(@rounds[@current_round]) == false
                split_match(lowest_seed_match(@rounds[@current_round])) 
            elsif round_empty?(@rounds[@current_round])
                @current_round +=1
            end
        end
    end

    def lowest_seed_match(round)
	    lowest_seed = -1
	    lowest_match = nil
	    round.each do |match|
	        if match.player2_id != nil and match.player2_id > lowest_seed
	            lowest_match = match
	            lowest_seed = match.player_2
	        elsif match.player1_id == nil and match.player2_id == nil
	            lowest_seed = lowest_seed
	        elsif match.player2_id == nil and match.player_1 > lowest_seed
	            lowest_match = match
	            lowest_seed = match.player_1
	        end
	    end
	    return lowest_match
	end

	
end
