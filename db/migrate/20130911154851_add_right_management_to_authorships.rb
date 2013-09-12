class AddRightManagementToAuthorships < ActiveRecord::Migration
  def change
    add_column :authorships, :can_edit_book, :boolean, :default => false
    add_column :authorships, :can_invite_authors, :boolean, :default => false
    add_column :authorships, :can_delete_authors, :boolean, :default => false
    add_column :authorships, :can_manage_authors, :boolean, :default => false
  end
end
