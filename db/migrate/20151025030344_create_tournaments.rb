class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
    	t.string :name
    	t.text :description
    	t.string :address
    	t.string :game
    	
     	t.timestamps
    end
  end
end
