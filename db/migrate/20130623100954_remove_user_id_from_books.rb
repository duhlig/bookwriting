class RemoveUserIdFromBooks < ActiveRecord::Migration
  def up
    remove_column :books, :user_id
  end

  def down
    add_column :books, :user_id, :integer
  end
end
