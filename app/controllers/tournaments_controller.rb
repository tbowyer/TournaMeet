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
		@total_rounds = @tournament.matches.maximum("round")
		@ordered_matches = @tournament.matches.order(:number)
		@test = @total_rounds
	end

	def register
		@tournament = Tournament.find(params[:id])
		x = 1
		#The number of users registered is hard coded in for now to test.
		User.all[0..3].each do |u|
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

	def delete_tournament
		@tournament = Tournament.find(params[:id])
		@tournament.destroy
		redirect_to root_path
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
