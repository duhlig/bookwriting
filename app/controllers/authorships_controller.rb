class AuthorshipsController < ApplicationController
  before_filter :authenticate_user!

  def revoke
    @authorship = Authorship.find(params[:id])
    if @authorship.user_is_author?(current_user)
      @authorship.destroy
      redirect_to :back, :notice => "Revoked #{@authorship.user.name}s access to #{@authorship.book.title}"
    else
      redirect_to :back, :notice => "No permission"
    end
  end

end
