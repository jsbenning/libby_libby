class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @users = User.all
    else
      flash[:notice] = "You don't have permission to access this page!"
      render '/home/index'
    end
  end

  def show
    @user = User.find(params[:id])
    @rating = @user.user_rating
    if current_user.admin? || current_user == @user
      render :show
    else
      flash[:notice] = "You don't have permission to access this page!"
      render '/home/index'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to :root, notice: 'User Info Updated!'
    else
      render 'edit'
    end
  end


  private

  def user_params
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode, :role)
  end
end