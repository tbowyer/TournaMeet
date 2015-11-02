class AddTagToUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.string :tag
  	end
  end
end
