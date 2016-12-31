class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.mid_clearance?
      @users = User.all
    else
      flash[:notice] = "You don't have permission to access that page!"
      render '/home/index'
    end
  end

  def show
    @user = User.find(params[:id])
    @rating = @user.user_rating
    unless current_user.mid_clearance? || current_user == @user
      flash[:notice] = "You don't have permission to access that page!"
      render '/home/index'
    end
  end

  def edit
    @user = User.find(params[:id])
    unless current_user.admin? || current_user == @user
      flash[:notice] = "You don't have permission to access that page!"
      render '/home/index'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) 
      redirect_to :root, notice: 'User Info Updated!'
    else
      flash[:notice] = "User Info Not Updated!"
      render '/home/index'
    end
  end

  def destroy
    if current_user.admin?
      @user = User.find(params[:id])
      @user.destroy
      redirect_to 'home/index'
    else
      flash[:notice] = "User Not Deleted!"
      render '/home/index'
    end
  end

  private

  def user_params
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode, :role)
  end
end