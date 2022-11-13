require 'rails_helper'

RSpec.describe 'merchant bulk discounts index page' do 
  before :each do 
    @merchant1 = Merchant.create!(name: 'Lisa Frank Knockoffs')
    @merchant2 = Merchant.create!(name: 'Fun Testing')
    @item1 = @merchant1.items.create!(name: 'Trapper Keeper', description: 'Its a Lisa Frank Trapper Keeper', unit_price: 3000)
    @item2 = @merchant2.items.create!(name: 'Pencil', description: 'Its a Lisa Frank Trapper Keeper', unit_price: 25)
    @item3 = @merchant2.items.create!(name: 'Soggy Gummy Worm', description: 'Its a Lisa Frank Trapper Keeper', unit_price: 1000)
    @item4 = @merchant2.items.create!(name: 'Eraser', description: 'Its a Lisa Frank Trapper Keeper', unit_price: 5000)
    @item5 = @merchant2.items.create!(name: 'Folder', description: 'Its a Lisa Frank Trapper Keeper', unit_price: 50)
    @item6 = @merchant2.items.create!(name: 'Kevin Ta Action Figure', description: 'The coolest action figure around!', unit_price: 10000)
    @item7 = @merchant2.items.create!(name: 'Water Bottle', description: 'Drink water!', unit_price: 10)
    @customer5 = Customer.create!(first_name: 'Swell', last_name: 'Sally')
    @invoice6 = @customer5.invoices.create!(status: 2, created_at: "2020-10-04 11:00:00 UTC")
    @invoice7 = @customer5.invoices.create!(status: 2, created_at: "2022-11-02 11:00:00 UTC")
    @invoice8 = @customer5.invoices.create!(status: 2, created_at: "2010-7-02 08:00:00 UTC")
    @invoice6 = @customer5.invoices.create!(status: 2, created_at: "2020-2-02 08:00:00 UTC")
    InvoiceItem.create!(invoice: @invoice6, item: @item2, quantity: 1, unit_price: 20)
    InvoiceItem.create!(invoice: @invoice8, item: @item3, quantity: 1, unit_price: 30)
    InvoiceItem.create!(invoice: @invoice7, item: @item4, quantity: 1, unit_price: 40)
    InvoiceItem.create!(invoice: @invoice6, item: @item5, quantity: 1, unit_price: 50)
    InvoiceItem.create!(invoice: @invoice8, item: @item6, quantity: 1, unit_price: 60)
    InvoiceItem.create!(invoice: @invoice6, item: @item7, quantity: 1, unit_price: 10)
    @invoice6.transactions.create!(result: 0)
    @invoice7.transactions.create!(result: 0)
    @invoice8.transactions.create!(result: 0)
    @discount1 = @merchant1.bulk_discounts.create!(discount: 20, quantity_threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(discount: 10, quantity_threshold: 5)
    @discount3 = @merchant2.bulk_discounts.create!(discount: 15, quantity_threshold: 15)
  end 

  describe 'as a merchant when i visit my merchant dashboard' do 

    it 'i see a link to view all my discounts, this link takes me to bulk discounts index page' do
      visit "/merchants/#{@merchant1.id}/dashboard"
      # require 'pry'; binding.pry
      click_link "My Discounts"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    end

    it 'i see all of my bulk discounts including percentage and quantity thresholds, each link goes to discount show page' do 
      visit "/merchants/#{@merchant1.id}/dashboard"
      click_link "My Discounts"
      expect(page).to have_content("Percentage Discount: 20.0%")
      expect(page).to have_content("Merchant must purchase at least 10 items to use discount.")
      expect(page).to have_content("Percentage Discount: 10.0%")
      expect(page).to have_content("Merchant must purchase at least 5 items to use discount.")
      expect(page).to_not have_content("Percentage Discount: 15.0%")
      expect(page).to_not have_content("Merchant must purchase at least 15 items to use discount.")
    end
  end

  describe 'when i visit my bulk discounts index page' do 
    it 'a link to create a new discount takes me to a form to create a new discount and brings me back to index where my discount is listed' do 
      visit merchant_bulk_discounts_path(@merchant1)
      click_button "Create a New Discount"
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
      expect(page).to have_content("Create a New Bulk Discount")
      fill_in :discount, with: 30
      fill_in :quantity_threshold, with: 50
      click_button "Submit"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
   
      expect(page).to have_content("Percentage Discount: 20.0%")
      expect(page).to have_content("Merchant must purchase at least 10 items to use discount.")
      expect(page).to have_content("Percentage Discount: 30.0%")
      expect(page).to have_content("Merchant must purchase at least 50 items to use discount.")
      expect(page).to_not have_content("Percentage Discount: 15.0%")
      expect(page).to_not have_content("Merchant must purchase at least 15 items to use discount.")
    end

    it 'i can delete a discount and it takes me back to index page and discount is deleted' do 
      visit merchant_bulk_discounts_path(@merchant1)
      expect(page).to have_content("Percentage Discount: 20.0%")
      expect(page).to have_content("Merchant must purchase at least 10 items to use discount.")
      expect(page).to have_content("Percentage Discount: 10.0%")
      expect(page).to have_content("Merchant must purchase at least 5 items to use discount.")

      within "#discount-list-#{@discount1.id}" do 
        click_button "Delete Discount"
        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      end
      expect(page).to_not have_content("Percentage Discount: 20.0%")
      expect(page).to_not have_content("Merchant must purchase at least 10 items to use discount.")
      expect(page).to have_content("Percentage Discount: 10.0%")
      expect(page).to have_content("Merchant must purchase at least 5 items to use discount.")

    end

    it 'each discount includes a link to its show page' do 
      visit merchant_bulk_discounts_path(@merchant1)
      click_link "Percentage Discount: #{@discount1.discount}"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    end


  end

end