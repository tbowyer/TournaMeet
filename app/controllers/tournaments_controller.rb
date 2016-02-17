class TournamentsController < ApplicationController
	def index
		@tournaments = Tournament.all
	end

	def new
		@tournament = Tournament.new
	end

	def create
		Tournament.create(place_params)
		redirect_to root_path
	end

	def show
		@tournament = Tournament.find(params[:id])
		@matches = @tournament.matches.sort_by {|match| match.round}
		@rounds = @tournament.matches.maximum("round")
		@round3 = @tournament.matches.where(:round => 3).order(:number)
		@round2 = @tournament.matches.where(:round => 2).order(:number)
		@round1 = @tournament.matches.where(:round => 1).order(:number)
	end

	def register
		@tournament = Tournament.find(params[:id])
		x = 1
		User.all[0..15].each do |u|
			if TournamentUser.exists?(:user => u, :tournament_id => @tournament.id)				
				flash[:error] = 'You are already registered for this tournament.'
			else
				TournamentUser.create(tournament: @tournament, user: u, seed: x)
				x += 1	
			end	
		end
		redirect_to tournament_path(@tournament)
	end

	def start
		@tournament = Tournament.find(params[:id])
		@tournament.add_matches()
		redirect_to tournament_path(@tournament)
	end

	private

	def place_params
		params.require(:tournament).permit(:name, :address, :game, :description)
	end

	def tournament_user_params
		@tournament = Tournament.find(params[:id])
		params.permit(:tournament_id, :user_id)
	end
end
