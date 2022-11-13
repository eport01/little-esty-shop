class Invoice < ApplicationRecord
  enum status: { cancelled: 0,  "in progress" => 1, completed: 2}
  belongs_to :customer 
  has_many :transactions 
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :invoice_items 


  
  
  def total_revenue #for an invoice, not including discounts (need non_discount_revenue?) 
    invoice_items.sum("quantity * unit_price")
  end

 

  def discount_revenue #returns discount but need to add transaction table data
    invoice_items.joins(:bulk_discounts, :discount_invoice_items).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").sum("invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.discount)").to_i
    # @invoice3.bulk_discounts.first.discount
  end

  def self.unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end
end

