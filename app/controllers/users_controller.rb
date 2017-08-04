class UsersController < ApplicationController
  before_save :capitalize_fields
  
  def index
    if current_user.mod_or_admin?
      @users = User.all
      respond_to do |f|
        f.html { render :index }
        f.json { render json: @users}
      end
    elsif current_user
      @msg = "You don't have the authority to access all users..."
      flash.now[:notice] = @msg
      respond_to do |f|
        f.html { render 'home/logged_in' }
        f.json { render :json => {:msg => @msg }}
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @rating = @user.rating
    if @user.admin? || @user == current_user 
    respond_to do |f|
      f.html { render :show }
      f.json { render json: @user.as_json(include: :books) }
    end
    else
      flash.now[:notice] = "You don't have permission..." 
      redirect_to 'home/logged_out'
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.admin? || @user == current_user 
    respond_to do |f|
      f.html { render :edit }
      f.json { render json: @user}
    end
    else
      flash.now[:notice] = "You don't have permission..." 
      redirect_to 'home/logged_out'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user || @user.admin?
      if @user.update_attributes(user_params) 
        redirect_to root_path, notice: 'User Info Updated!'
      else
        flash.now[:notice] = "All fields must be filled in..."
        render "users/edit"
      end
    else
      flash.now[:notice] = "You don't have permission..." 
      redirect_to 'home/logged_out' 
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

  def capitalize_fields
    self.real_name.split(" ").each{|w| w.capitalize!()}.join(" ")
  end
 

  def user_params
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode, :role, :visible)
  end
end