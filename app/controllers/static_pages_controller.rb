class StaticPagesController < ApplicationController
  def home
    # `.build()` returns an object in memory but doesn't modify
    # the database; in fact, `.build()` is just an alias for `.new()`.
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
