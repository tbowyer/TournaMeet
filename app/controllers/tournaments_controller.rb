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
	end

	def register
		@tournament = Tournament.find(params[:id])
		TournamentUser.create(tournament: @tournament, user: current_user)
		redirect_to tournament_path

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
