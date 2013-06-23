class AuthorshipsController < ApplicationController
  def revoke
    @authorship = Authorship.find(params[:id])
    @authorship.destroy
    redirect_to :back, :notice => "Revoked #{@authorship.user.name}s access to #{@authorship.book.title}"
  end
end
