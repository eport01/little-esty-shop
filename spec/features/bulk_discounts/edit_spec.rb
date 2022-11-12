require 'rails_helper'

RSpec.describe 'merchant bulk discount edit page' do 
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

  describe 'when a merchant clicks on edit discount button on merchant discount show page' do 
    it 'merchant is taken to an edit page where the attributes are prepopulated' do 
      visit merchant_bulk_discount_path(@merchant1, @discount2)
      click_button "Edit Discount"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount2))
    end

    it 'when i cahnge any/all of the info and submit, i am redirected to discounts show page and attributes have been updated' do 
      visit edit_merchant_bulk_discount_path(@merchant1, @discount2)
      expect(page).to have_content("Edit Discount Page")

      expect(page).to have_field('Bulk Discount Percentage', with:"#{@discount2.discount}")
      expect(page).to have_field('Quantity Threshold', with:"#{@discount2.quantity_threshold}")
      fill_in('Bulk Discount Percentage', with: 20)

      click_button "Submit"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount2))
      expect(page).to have_content('Discount: 20')
      expect(page).to have_content('Quantity Threshold: 5 items to use discount.' )
      expect(page).to have_button("Edit Discount")

    end
  end

end 