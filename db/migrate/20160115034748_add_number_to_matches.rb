class AddNumberToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :number, :integer	
  end
end
