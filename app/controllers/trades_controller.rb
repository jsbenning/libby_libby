class TradesController < ApplicationController
  def index
    @trades_requested = Trade.trades_requested(current_user)
    @trades_received = Trade.trades_received(current_user)
  end
  
  def new
  end

  def create
    @trade = Trade.new(trade_params)
  end

  def edit
    @trade = Trade.find(params[:id])
  end

  def update
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      redirect_to "/trades"
    else
      render 'edit'
    end
  end

  private
  def trade_params
    params.require(:trade).premit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status)
  end

end


    create_table :trades do |t|
      t.integer :owner_id
      t.integer :requester_id
      t.integer :initial_book_id
      t.integer :matched_book_id
      t.string :status, default: "pending" #or 'complete'


        def edit
    @attraction = Attraction.find(params[:id])
  end

  def update
    @attraction = Attraction.find(params[:id])
    if @attraction.update_attributes(attraction_params)
      redirect_to "/attractions/#{@attraction.id}"
    else
      render 'edit'
    end
  end