class TradesController < ApplicationController

  def index
    @my_trades = Trade.my_trades(current_user)
    @user = current_user
    if @my_trades.empty?
      @msg = "You don't have any trades yet!"
    else
      @msg = "Check out your trades below..."
    end
    @my_initiated_trades =[]
    @my_must_respond_trades = []
    @my_completed_initiated_trades = []
    @my_completed_responded_trades = []
    @my_trades.each do |trade|
      if trade.first_trader == current_user && trade.book_second_trader_wants_id.nil?
        @my_initiated_trades << trade.to_json(:include => [:first_trader, :book_first_trader_wants, :second_trader])
      elsif trade.second_trader == current_user && trade.book_second_trader_wants_id.nil?
        @my_must_respond_trades << trade.to_json(:include => [:first_trader, :book_first_trader_wants])
      elsif trade.status == "complete" && trade.first_trader == current_user
        @my_completed_initiated_trades << trade.to_json(:include => [:first_trader, :book_first_trader_wants, :second_trader, :book_second_trader_wants])
      else
        @my_completed_responded_trades << trade.to_json(:include => [:first_trader, :book_first_trader_wants, :second_trader, :book_second_trader_wants])
      end
    end
    respond_to do |f|
      flash.now[:notice] = @msg
      f.html { render :index }
      f.json { render :json => { :my_initiated_trades => @my_initiated_trades, :my_must_respond_trades => @my_must_respond_trades, \
      :my_completed_initiated_trades => @my_completed_initiated_trades, :my_completed_responded_trades => @my_completed_responded_trades, :msg => @msg }}
    end
  end

  def create # This is created with first_trader_id, second_trader_id and book_first_trader_wants_id attributes, status "new";
    # also there is no 'new' action, as a trade is instantiated through the book show form by current user as first trader
    @trade = Trade.new(trade_params)
    if @trade.first_trader.shipworthy? #&& !(@trade.first_trader.books.empty?)
      setup_a_trade(@trade)
      @my_trades = Trade.my_trades(current_user)
      @msg = "You just created a trade! Well done #{current_user.real_name}!"
      respond_to do |f|
        f.html { redirect_to trades_path_url, notice: @msg }
        f.json { render :json => { :my_trades => @my_trades, :msg => @msg }}
      end
    else
      destroy_a_trade(@trade)
      @msg = 'There was a problem creating a trade (make sure your shipping info is complete and you have a book to trade)!'
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_in' }
        f.json { render :json => { :msg => @msg }}
      end
    end
  end

  def update # This completes a trade by adding a second book, which also allows trade users i.e. traders, to be rated
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      complete_a_trade(@trade)
      if current_user == @trade.first_trader
        @my_book = @trade.book_second_trader_wants
      else
        @my_book = @trade.book_first_trader_wants
      end
      @my_trades = Trade.my_trades(current_user)
      @msg = "Trade info updated!"
      respond_to do |f|
        f.html { redirect_to 'trades/index', notice: @msg }
        f.json { render :json => { :my_trades => @my_trades, :my_book => @my_book, :msg => @msg }}
      end
    else
      @msg = "Trade not updated! Something happened!"
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_in' }
        f.json { render :json => { :msg => @msg }}
      end
    end
  end

  def destroy # This cancels a trade
    @trade = Trade.find(params[:id])
    if @trade.second_trader_id == current_user.id || @trade.first_trader_id == current_user.id
      destroy_a_trade(@trade)
      @msg = 'Trade deleted! And sent to Hell! (Actually, it was just deleted...)'
      respond_to do |f|
        f.html { redirect_to 'trades/index', notice: @msg }
        f.json { render :json => { :my_trades => @my_trades, :msg => @msg }}
      end
    else
      @msg = "You don't have permission to delete that trade! Cut it out!"
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_in' }
        f.json { render :json => { :msg => @msg }}
      end
    end
  end

  private

  def setup_a_trade(trade)

    book_id = trade.book_first_trader_wants_id
    book_first_trader_wants = Book.find(book_id)
    book_first_trader_wants.status = 'traded'
    trade.save
    book_first_trader_wants.request_id = trade.id
    book_first_trader_wants.save
  end


  def complete_a_trade(trade)
    book_id = trade.book_second_trader_wants_id
    book_second_trader_wants = Book.find(book_id)
    book_second_trader_wants.status = 'traded'
    trade.status = 'complete'
    trade.save
    book_second_trader_wants.response_id = trade.id
    book_second_trader_wants.save
  end

  def destroy_a_trade(trade)
    book1_id = trade.book_first_trader_wants_id
    book_first_trader_wants = Book.find(book1_id)
    book_first_trader_wants.status = 'at_home'
    book_first_trader_wants.request_id = nil
    book_first_trader_wants.save
    if trade.book_second_trader_wants_id
      book2_id = trade.book_second_trader_wants_id
      book_second_trader_wants = Book.find(book2_id)
      book_second_trader_wants.status = 'at_home'
      book_second_trader_wants.response_id = nil
      book_second_trader_wants.save
    end
    trade.destroy
  end


  def trade_params
    params.require(:trade).permit(:first_trader_id, :second_trader_id, :book_first_trader_wants_id, :book_second_trader_wants_id, :status, :first_trader_rating, :second_trader_rating)
  end

end
