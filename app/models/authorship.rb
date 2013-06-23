class Authorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  def user_is_author?(user)
    Authorship.exists?({:book_id => self.book.id, :user_id => user.id})
  end
end
