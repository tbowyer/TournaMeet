class AddWinnerToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :winner, :integer
  end
end
