class MatchesController < ApplicationController

	def show
		@match = Match.find(params[:id])
	end

	def report_match
		
	end
	
	
end
