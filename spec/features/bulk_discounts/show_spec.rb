require 'rails_helper'

RSpec.describe 'merchant bulk discount show page' do 
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
    @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, quantity_threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(discount: 0.10, quantity_threshold: 5)
    @discount3 = @merchant2.bulk_discounts.create!(discount: 0.15, quantity_threshold: 15)
  end 

  describe 'when i visit bulk discount show page' do 
    it 'shows discounts quanitity threshold and percentage discount' do 
      visit merchant_bulk_discount_path(@merchant1, @discount1)
      expect(page).to have_content("Percentage Discount: 20.0%")
      expect(page).to have_content("Quantity Threshold: 10")
      expect(page).to_not have_content("Percentage Discount: 10.0%")
      
      visit merchant_bulk_discount_path(@merchant1, @discount2)
      expect(page).to have_content("Percentage Discount: 10.0%")
      expect(page).to have_content("Quantity Threshold: 5")
      expect(page).to_not have_content("Percentage Discount: 20.0%")
      
    
    end

    it 'i can click a button to edit a discount and am taken to an edit form' do 
      visit merchant_bulk_discount_path(@merchant1, @discount2)


      click_button "Edit Discount"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount2))
      expect(page).to have_field('Bulk Discount Percentage', with:"#{@discount2.discount}")
      expect(page).to have_field('Quantity Threshold', with:"#{@discount2.quantity_threshold}")
    end

    it 'lists items that this discount is used on' do 
      visit merchant_bulk_discount_path(@merchant1, @discount2)

    end
  end

  
  before :each do 
    @merchant1 = Merchant.create!(name: "Kevin's Illegal goods")
    @merchant2 = Merchant.create!(name: "Denver PC parts")

    @customer1 = Customer.create!(first_name: "Sean", last_name: "Culliton")
    @customer2 = Customer.create!(first_name: "Sergio", last_name: "Azcona")
    @customer3 = Customer.create!(first_name: "Emily", last_name: "Port")

    @item1 = @merchant1.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 5000)
    @item2 = @merchant1.items.create!(name: "T-Rex", description: "Skull of a Dinosaur", unit_price: 100000)
    @item3 = @merchant2.items.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 400)
    @item4 = @merchant2.items.create!(name: "Alarm Clock", description: "Wakes you up", unit_price: 400)

    @invoice1 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer1.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id, created_at: "2022-11-01 11:00:00 UTC")
    
    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 =InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @item2.id, invoice_id: @invoice1.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @item3.id, invoice_id: @invoice2.id)
    @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)
    @invoice_item5 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item4.id, invoice_id: @invoice3.id)
    @invoice_item6 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 2, item_id: @item1.id, invoice_id: @invoice3.id)

    @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, quantity_threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(discount: 0.10, quantity_threshold: 5)
    @discount3 = @merchant2.bulk_discounts.create!(discount: 0.15, quantity_threshold: 15)

    DiscountInvoiceItem.create!(invoice_item: @invoice_item3, bulk_discount: @discount1)
    DiscountInvoiceItem.create!(invoice_item: @invoice_item4, bulk_discount: @discount1)
    DiscountInvoiceItem.create!(invoice_item: @invoice_item5, bulk_discount: @discount1)
  end


end