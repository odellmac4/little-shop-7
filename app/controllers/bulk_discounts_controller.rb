class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
end

def show
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
    @discount = @discounts.find(params[:id])
end

def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
end

def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.create!(discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
end

def destroy
  @merchant = Merchant.find(params[:merchant_id])
  BulkDiscount.find(params[:id]).destroy
  redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
end

def update
end

private

def discount_params
    params.permit(:percentage_discount, :quantity_threshold, :merchant_id)
end
end