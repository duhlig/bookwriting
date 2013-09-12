class Authorship < ActiveRecord::Base
  attr_accessible :can_edit_book, :can_invite_authors, :can_delete_authors, :can_manage_authors, :user_id

  belongs_to :user
  belongs_to :book

  def user_is_author?(user)
    Authorship.exists?({:book_id => self.book.id, :user_id => user.id})
  end

end
