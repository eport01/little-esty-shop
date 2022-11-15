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

 
  def self.unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end


  def discount_revenue #total amount of discount, money off 
    from_sql = 
    invoice_items
    .joins(:bulk_discounts)
    .select('max(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.discount) as revenue')
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group(:id).to_sql

    InvoiceItem 
    .select('sum(revenue) best_revenue').from("(#{from_sql}) as sql").take.best_revenue.to_i

  end

  def after_discounts
    total_revenue - discount_revenue 
  end

end

