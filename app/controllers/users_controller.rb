class UsersController < ApplicationController
  
  def index
    if current_user.mod_or_admin?
      @users = User.all
      respond_to do |f|
        f.html { render :index}
        f.json { render json: @users}
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |f|
      f.html { render :show}
      f.json { render json: @user.as_json(include: :books) }
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |f|
      f.html { render :edit}
      f.json { render json: @user}
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) 
      redirect_to :root, notice: 'User Info Updated!'
    else
      flash[:notice] = "All Fields Must Be Filled In..."
      render "users/edit"
    end
  end

  # def destroy #let devise handle this?
  #   @user = User.find(params[:id])
  #   if (current_user.admin || current_user == @user)  
  #     @user.destroy
  #     flash[:notice] = "User Deleted!"
  #     redirect_to root_url
  #   else
  #     flash[:notice] = "User Not Deleted!"
  #     render 'home/logged_out'
  #   end
  # end

  private


    

  def user_params
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode, :role, :visible)
  end
end