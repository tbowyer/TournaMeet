class AddSeedToTournamentUsers < ActiveRecord::Migration
  def change
  	add_column :tournament_users, :seed, :integer
  end
end
