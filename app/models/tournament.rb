class Tournament < ActiveRecord::Base
	has_many :users, :through => :tournament_users
	has_many :tournament_users
end
