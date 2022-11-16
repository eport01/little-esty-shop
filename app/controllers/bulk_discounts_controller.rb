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
    @bulk_discount = @merchant.bulk_discounts.create(bulk_discount_params)
    if @bulk_discount.valid?
      @bulk_discount.save 
      redirect_to merchant_bulk_discounts_path(@merchant)
    else  
      flash[:notice] = 'Please Enter a Valid decimal between 0 and 1'
      render :new 
    end
  end

  def destroy 
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy 
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def show 
    @merchant = Merchant.find(params[:merchant_id])

    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update 
    @merchant = Merchant.find(params[:merchant_id]) 
    @bulk_discount = BulkDiscount.find(params[:id])

    @bulk_discount.update(bulk_discount_params)
    if @bulk_discount.valid?
      @bulk_discount.save 
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash[:notice] = 'Please Enter a Valid decimal between 0 and 1'
      render :edit 
    end

  end

  private 
  def bulk_discount_params
    params.permit(:discount, :quantity_threshold)
  end
end