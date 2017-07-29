class TradesController < ApplicationController

  def index
    @user = current_user
    @user_trades = Trade.user_trades(@user)
  end
  
  def create # Is created with trader_one and book_trader_one_wants attributes
    @trade = Trade.create(trade_params)
    if @trade.save && @trade.book_trader_one.shipworthy? && !(@trade.book_trader_one.books.empty?)
        book_trader_one_wants = Book.find(@trade.book_trader_one_wants_id)
        book_trader_one_wants.status = 'traded'
        book_trader_one_wants.save
        @trade.status = "new"
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
      book_trader_two_wants = Book.find(@trade.book_trader_two_wants_id)
      book_trader_two_wants.status = 'traded'
      @trade.status = 'complete'
      @trade.save
      redirect_to action: 'index'
    else
      flash[:notice] = 'Sorry, trade not updated!'
      render :root
    end
  end

  def destroy #this cancels a trade
    @trade = Trade.find(params[:id])
    if @trade.book_trader_two_id == current_user.id || @trade.book_trader_one_id == current_user.id
      book_trader_one_wants = Book.find(@trade.book_trader_one_wants_id)
      book_trader_one_wants.status = 'at_home'
      book_trader_one_wants.save
      if @trade.book_trader_two_wants_id
        book_trader_two_wants = Book.find(@trade.book_trader_two_wants_id)
        book_trader_two_wants.status = 'at_home'
        book_trader_two_wants.save
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
    params.require(:trade).permit(:book_trader_one_wants_id, :book_trader_two_wants_id, :status, :trader_one_rating, :trader_two_rating)
  end

end


 