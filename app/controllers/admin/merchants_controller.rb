class Admin::MerchantsController < ApplicationController
    def index
        @merchants = Merchant.all
        @top_merchants = Merchant.merchant_best_day_by_revenue
    end

    def show
        @merchant = Merchant.find(params[:id])
    end

    def new
        @merchant = Merchant.new
    end

    def create
        @merchant = Merchant.new(merchant_params)
        if @merchant.save
            redirect_to admin_merchants_path
        else
            flash[:alert] = "Error. Please enter a name."
            render :new
        end
    end

    def edit
        @merchant = Merchant.find(params[:id])
    end

    def update
        @merchant = Merchant.find(params[:id])

        if params[:change_status].present?
            @merchant.change_status
            redirect_to "/admin/merchants/index"
        else
            if @merchant.update(merchant_params)
                flash[:notice] = "Merchant information is updated successfully"
            end
            redirect_to admin_merchant_path
        end

        # Original #update
        # if merchant.update(merchant_params)
        #     flash[:notice] = "Merchant information is updated successfully"
        #     redirect_to admin_merchant_path(merchant)
        # end
    end

    private

    def merchant_params
        params.require(:merchant).permit(:id, :name)
    end
end
