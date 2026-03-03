class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  
  # display all users page
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # display user page
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # sign up page
  def new
    @user = User.new
  end

  # sign up (post request)
  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App!"

      # equivalent to: 'redirect_to user_url(@user)'
      redirect_to @user
    else
      # http status code 422
      render 'new', status: :unprocessable_entity
    end
  end

  # update page
  def edit
  end

  # update user attributes (patch request)
  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated!"

      # equivalent to: 'redirect_to user_url(@user)'
      redirect_to @user
    else
      # http status code 422
      render 'edit', status: :unprocessable_entity
    end
  end

  # delete user (delete request)
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted!"
    redirect_to users_url, status: :see_other
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters:
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."

        # http status code 303
        redirect_to login_url, status: :see_other
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])

      # http status code 303
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
