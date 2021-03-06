class VersionsController < ApplicationController
  before_filter :authenticate_user!

  def revert
      @version = Version.find(params[:id])
      @version.reify.save!
      redirect_to :back, :notice => "Undid #{@version.event}"
  end
end
