class AddStartedFieldToTournaments < ActiveRecord::Migration
  def change
  	add_column :tournaments, :started, :boolean, :default => false
  end
end
