class AddChildrenToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :child_one_id, :integer
  	add_column :matches, :child_two_id, :integer
  end
end
