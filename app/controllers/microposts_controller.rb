class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # create new micropost (post request)
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted!"

    # For a multitude of reasons, `request.referrer` (whose
    # source is the browser's HTTP "Referer" header, and which may
    # be used by this `redirect_back_or_to` method) may be nil,
    # in which case we redirect to `root_url` by default.
    redirect_back_or_to(root_url, status: :see_other)
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to(root_url, status: :see_other) if @micropost.nil?
    end
end
