class BulkDiscountsController < ApplicationController
  def index  
    @merchant = Merchant.find(params[:merchant_id])
    if params[:merchant_id]
      @merchant.bulk_discounts
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def destroy 
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy 
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private 
  def bulk_discount_params
    params.permit(:discount, :quantity_threshold)
  end
end