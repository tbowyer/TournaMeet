class MatchesController < ApplicationController

	def show
		@match = Match.find(params[:id])
		@player1 = @match.player1_id
		@player2 = @match.player2_id
	end

	def report_match
		@match = Match.find(params[:match_id])
		@next_match = Match.find(@match.next_match_id)
		#figure out way to pass in the winners id here
		
		#if the current match is child 1 of the next match, move the winn into position 2. 
		#if the current match is child 2, move the winner into position 1
		@match.winner = @match.player1_id
		if Match.find(@next_match.child_one_id) == @match
			@next_match.update_attributes(:player2_id => @match.winner)
			redirect_to tournament_match_path(@next_match.id)
		elsif Match.find(@next_match.child_two_id) == @match
			@next_match.update_attributes(:player1_id => @match.winner)
			redirect_to tournament_match_path(@next_match.id)
		end
	end

	def update
	end

	
	
end
