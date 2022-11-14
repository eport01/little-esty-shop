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

 

  # def discount_revenue #returns discount but need to add transaction table data
  #   invoice_items.joins(:bulk_discounts, :discount_invoice_items, invoice: :transactions)
  #   .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
  #   .where('transactions.result = 0')
  #   .sum("invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.discount)")
  #   .to_i
  # end
  # @discount1.merchant.invoices.first.invoice_items.first.unit_price
  def self.unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end


  def discount_revenue #total amount of discounted revenue, money off 
    from_sql = 
    invoice_items
    .joins(:bulk_discounts)
    .select('min(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.discount) as revenue')
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group(:id).to_sql

    InvoiceItem 
    .select('sum(revenue) best_revenue').from("(#{from_sql}) as sql").take.best_revenue

  end

  def after_discounts
    total_revenue - discount_revenue 
  end
  #@invoice3.discount_revenue.take.best_revenue

  # def best_discount #finds best discount for invoice_item
  #   bulk_discounts.maximum(:discount)
  # end



  # bulk_discounts.minimum(:discount)
  #invoice_item2.bulk_discounts.min
end

