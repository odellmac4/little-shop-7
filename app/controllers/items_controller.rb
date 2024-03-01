class ItemsController < ApplicationController
    def index
      @merchant = Merchant.find(params[:merchant_id])
      @top_items = @merchant.calculate_top_items
      # @top_items_withdate = @merchant.calculate_topitems_date(top_items)
    end
    def show
      @merchant = Merchant.find(params[:merchant_id])

      @item = Item.find(params[:id])

    end

    def edit
      @merchant = Merchant.find(params[:merchant_id])

      @item = Item.find(params[:id])

    end

    def update
      merchant = Merchant.find(params[:merchant_id])
      item = Item.find(params[:id])
      if params[:commit].include?("Enable") || params[:commit].include?("Disable")
        item.change_status(params[:commit])
        redirect_to merchant_items_path(merchant_id: merchant.id)
      else
        item.update(item_params)
        flash[:notice] = 'Item successfully updated.'
        redirect_to merchant_item_path(merchant_id: merchant.id, id: item.id)
      end
    end

    def new
      @merchant = Merchant.find(params[:merchant_id])
    end

    def create
      @merchant = Merchant.find(params[:merchant_id])
      item = Item.create!(item_params)
      redirect_to merchant_items_path(merchant_id: @merchant.id)
    end

  private

  def item_params
    params.permit(:name, 
                  :description, 
                  :unit_price, 
                  :merchant_id, 
                  :has_discount)
  end

  end
