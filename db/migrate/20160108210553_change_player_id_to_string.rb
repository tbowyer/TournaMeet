class ChangePlayerIdToString < ActiveRecord::Migration
  def change
  	change_column :matches, :player1_id, :string
  	change_column :matches, :player2_id, :string
  end
end
