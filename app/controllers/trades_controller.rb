class TradesController < ApplicationController

  def index
    @user = current_user
    @user_trades = Trade.user_trades(@user)
  end
  
  def create
    @trade = Trade.create(trade_params)
    if @trade.save && @trade.requester.shipworthy? && !(@trade.requester.books.empty?)
        initial_book = Book.find(@trade.initial_book_id)
        initial_book.status = 'traded'
        initial_book.save
        flash[:notice] = "You've just initiated a new trade! Please wait for a response soon."
      redirect_to action: 'index'
    else
      flash[:notice] = 'There was a problem creating a trade (make sure your shipping info is complete and you have a book to trade)!'
      render 'home/index'
    end
  end


  def update
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      matched_book = Book.find(@trade.matched_book_id)
      matched_book.status = 'traded'
      @trade.status = 'complete'
      @trade.save
      redirect_to action: 'index'
    else
      flash[:notice] = 'Sorry, trade not updated!'
      render 'home/index'
    end
  end

  def destroy
    @trade = Trade.find(params[:id])
    if @trade.owner_id == current_user.id || @trade.requester_id == current_user.id
      initial_book = Book.find(@trade.initial_book_id)
      initial_book.status = 'at_home'
      initial_book.save
      if @trade.matched_book_id
        matched_book = Book.find(@trade.matched_book_id)
        matched_book.status = 'at_home'
        matched_book.save
      end 
      @trade.destroy
      flash[:notice] = 'Trade deleted!'
      redirect_to root_path
    else
      flash[:notice] = "You don't have permission to delete this trade!"
      render 'home/index'
    end
  end

  private

  def trade_params
    params.require(:trade).permit(:requested_book_id, :matched_book_id, :status, :initial_book_owner_rating, :matched_book_owner_rating)
  end

end


 