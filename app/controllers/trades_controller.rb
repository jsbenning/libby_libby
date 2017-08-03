class TradesController < ApplicationController

  def index
    @my_trades = Trade.my_trades(current_user)
  end
  
  def create # This is created with first_trader_id, second_trader_id and book_first_trader_wants_id attributes, status "new"; 
    # also there is no 'new' action, as a trade is instantiated through the book show form 
    @trade = Trade.create(trade_params)
    if @trade.save && @trade.first_trader.shipworthy? && !(@trade.first_trader.books.empty?)
      setup_a_trade(@trade)
      @my_trades = Trade.my_trades(current_user)
      @msg = "You just created a trade!"
      respond_to do |f|
        f.html { redirect_to trades_path_url, notice: @msg }
        f.json { render :json => { :my_trades => @my_trades, :msg => @msg }}
      end
    else
      @msg = 'There was a problem creating a trade (make sure your shipping info is complete and you have a book to trade)!'
      respond_to do |f|
        f.html { render :index, notice: @msg }
        f.json { render :json => { :msg => @msg }} 
      end
    end
  end

  def update #this completes a trade by adding a second book, which also allows trade users i.e. traders, to be rated
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      complete_a_trade(@trade)
      if current_user == @trade.first_trader
        @other_trader = @trade.second_trader
        @my_book = @trade.book_second_trader_wants
      else
        @other_trader = @trade.first_trader
        @my_book = @trade.book_first_trader_wants
      end
      @my_trades = Trade.my_trades(current_user)
      @msg = "You just completed a trade.  See the info below and send out your book!"
      respond_to do |f|
        f.html { redirect_to(trades_index_url), notice: @msg }
        f.json { render :json => { :my_trades => @my_trades, :other_trader => @other_trader, :my_book => @my_book, :msg => @msg }}
      end
    else
      @msg = "Trade not updated!"
      respond_to do |f|
        f.html { render :index, notice: @msg }
        f.json { render :json { :msg => @msg }}
      end
    end
  end

  def destroy #this cancels a trade
    @trade = Trade.find(params[:id])
    if @trade.second_trader_id == current_user.id || @trade.first_trader_id == current_user.id
      destroy_a_trade(@trade) 
      @msg = 'Trade deleted!'
      respond_to do |f|
        f.html { redirect_to(trades_index_url), notice: @msg }
        f.json { render :json => { :my_trades => @my_trades, :msg => @msg }}
      end
    else
      @msg = "You don't have permission to delete that trade!" 
      respond_to do |f|
        f.html { render :index }
        f.json { render :json => { :msg => @msg }}
      end
    end
  end

  private

  def setup_a_trade(trade)
    book_first_trader_wants = Book.find(trade.book_first_trader_wants_id)
    book_first_trader_wants.status = 'traded'
    book_first_trader_wants.save
    trade.status = 'new'
    trade.save
  end


  def complete_a_trade(trade)
    book_second_trader_wants = Book.find(trade.book_second_trader_wants_id)
    book_second_trader_wants.status = 'traded'
    trade.status = 'complete'
    trade.save
  end

  def destroy_a_trade(trade)
    book_first_trader_wants = Book.find(trade.book_first_trader_wants_id)
    book_first_trader_wants.status = 'at_home'
    book_first_trader_wants.save
    if trade.book_second_trader_wants_id
      book_second_trader_wants = Book.find(trade.book_second_trader_wants_id)
      book_second_trader_wants.status = 'at_home'
      book_second_trader_wants.save
    end
    trade.destroy
  end 

  def trade_params
    params.require(:trade).permit(:first_trader_id, :second_trader_id, :book_first_trader_wants_id, :book_second_trader_wants_id, :status, :first_trader_rating, :second_trader_rating)
  end

end


 