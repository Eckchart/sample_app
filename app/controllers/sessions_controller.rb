class SessionsController < ApplicationController
  # log in page
  def new
  end

  # log in (post request)
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        log_in @user

        # `@user` is equivalent to the url `user_url(@user)`
        redirect_to forwarding_url || @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'

      # http status code 422
      render 'new', status: :unprocessable_entity
    end
  end

  # log out (delete request)
  def destroy
    log_out if logged_in?

    # http status code 303
    redirect_to root_url, status: :see_other
  end
end
