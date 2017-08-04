class UsersController < ApplicationController
  before_save :capitalize_fields
  
  def index
    if current_user.mod_or_admin?
      @users = User.all
      respond_to do |f|
        f.html { render :index }
        f.json { render :json => {:users => @users}}
      end
    else
      @msg = "You can't see all users, sorry..."
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @rating = @user.rating
    if @user.admin? || @user == current_user
      respond_to do |f|
        f.html { render :show }
        f.json { render json: => {:user => @user, :books => @books, :rating => @rating }}
      end
    else
      @msg = "You don't have permission to look at that user's info. Come on, now you're just being creepy."
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end
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
      @msg =  "You're not allowed to edit that account."  
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user || @user.admin?
      if @user.update_attributes(user_params)
      @msg = 'User Info Updated! Huzzah!'
      respond_to do |f|
        f.html { redirect_to root_path, notice: @msg }
        f.json { render :json => { :user => @user, :msg => @msg}}
      end   
      else
        @msg = "All fields must be filled in..."
        flash.now[:alert] = @msg
        respond_to do |f|
          f.html { render :edit }
          f.json { render :json => { :msg => @msg }}
        end
      end
    else
      flash.now[:alert] = "You're not allowed to edit that account." 
      respond_to do |f|
        f.html { render 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end  
    end
  end

  # def destroy # let devise handle this? I say yass!
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