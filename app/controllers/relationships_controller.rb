class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # follow user
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  # unfollow user
  def destroy
    # Since the request is like `DELETE /relationships/:id`,
    # params[:id] will correctly be the relationship between
    # the currently logged-in user and the user we wish to unfollow.
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user, status: :see_other }
      format.turbo_stream
    end
  end
end
