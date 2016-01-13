class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
    	t.integer :round
    	t.integer :player1_id
    	t.integer :player2_id
    	t.integer :next_match_id
    	t.integer :prev_match_id
    	


    	t.timestamps
    end
  end
end
