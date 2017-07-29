class TradesController < ApplicationController

  def index
    @user = current_user
    @my_trades = Trade.my_trades(@user)
  end
  
  def create # Is created with first_trader and book_first_trader_wants_id attributes
    @trade = Trade.create(trade_params)
    if @trade.save && @trade.book_first_trader.shipworthy? && !(@trade.book_first_trader.books.empty?)
        book_first_trader_wants = Book.find(@trade.book_first_trader_wants_id)
        book_first_trader_wants.status = 'traded'
        book_first_trader_wants.save
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
      book_second_trader_wants = Book.find(@trade.book_second_trader_wants_id)
      book_second_trader_wants.status = 'traded'
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
    if @trade.book_second_trader_id == current_user.id || @trade.book_first_trader_id == current_user.id
      book_first_trader_wants = Book.find(@trade.book_first_trader_wants_id)
      book_first_trader_wants.status = 'at_home'
      book_first_trader_wants.save
      if @trade.book_second_trader_wants_id
        book_second_trader_wants = Book.find(@trade.book_second_trader_wants_id)
        book_second_trader_wants.status = 'at_home'
        book_second_trader_wants.save
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
    params.require(:trade).permit(:book_first_trader_wants_id, :book_second_trader_wants_id, :status, :first_trader_rating, :second_trader_rating)
  end

end


 