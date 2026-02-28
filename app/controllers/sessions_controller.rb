class SessionsController < ApplicationController
  # log in page
  def new
  end

  # log in (post request)
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      log_in user

      # `user` is equivalent to the url `user_url(@user)`
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = 'Invalid email/password combination'

      # http status code 422
      render 'new', status: :unprocessable_entity
    end
  end

  # log out (delete request)
  def destroy
    log_out

    # http status code 303
    redirect_to root_url, status: :see_other
  end
end
