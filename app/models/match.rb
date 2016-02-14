class Match < ActiveRecord::Base
	has_many :users
	belongs_to :tournament
	attr_accessor :children

	private

	def is_full?
	  if self.player_1 and self.player_2
	  	return true
	  else
	  	return false
	  end
	end

	
end