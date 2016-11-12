class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
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
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode)
  end
end