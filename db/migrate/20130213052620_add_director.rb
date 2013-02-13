class AddDirector < ActiveRecord::Migration
  def up
    add_column :movies,:director,:string
  end
  
  def down
    remove_column :mvoies,:director
  end
end
