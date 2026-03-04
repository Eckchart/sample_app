class ApplicationController < ActionController::Base
  include SessionsHelper

  # NOTE: Unlike in Java or C++, private methods in Ruby
  # can be called from derived classes.
  private
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."

        # http status code 303
        redirect_to login_url, status: :see_other
      end
    end
end
