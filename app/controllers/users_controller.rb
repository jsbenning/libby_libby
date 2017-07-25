class UsersController < ApplicationController
  
  before_action :check_credentials, except: [:destroy, :index] #current_users cannot see all users OR destroy users, even themselves(?)

  def index
    if current_user.mod_or_admin?
      @users = User.all
    else
      flash[:notice] = "You don't have permission to access that page!"
      render '/home/logged_out'
    end
  end

  def show
    respond_to do |f|
      f.html { render :show}
      f.json { render json: @user}
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) 
      redirect_to :root, notice: 'User Info Updated!'
    else
      flash[:notice] = "User Info Not Updated!"
      render :root
    end
  end

  def destroy
    if current_user.admin?
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "User Deleted!"
      redirect_to 'home/index'
    else
      flash[:notice] = "User Not Deleted!"
      render :root
    end
  end

  private

  def check_credentials
    @user = User.find(params[:id])
    unless (current_user.mod_or_admin? || current_user == @user)
      flash[:notice] = "You don't have permission to access that page!"
      render '/home/index'
    end
  end
    

  def user_params
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode, :role)
  end
end