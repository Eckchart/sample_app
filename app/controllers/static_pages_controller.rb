class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # `.build()` returns an object in memory but doesn't modify
      # the database; in fact, `.build()` is just an alias for `.new()`.
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
