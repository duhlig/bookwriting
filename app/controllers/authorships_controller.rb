class AuthorshipsController < ApplicationController
  before_filter :authenticate_user!

  def revoke
    @authorship = Authorship.find(params[:id])
    if can_revoke?(@authorship.book_id, current_user.id)
      @authorship.destroy
      redirect_to :back, :notice => "Revoked #{@authorship.user.name}s access to #{@authorship.book.title}"
    else
      redirect_to :back, :notice => "No permission"
    end
  end

  private

  def can_revoke?(book_id, user_id)
    Authorship.exists?(:book_id => book_id, :user_id => user_id)
  end

end
