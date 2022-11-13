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

 

  def discount_revenue 
    #tables: invoice_items, bulk_discounts 
    #@merchant2.items.first.invoice_items.first.bulk_discounts
    #sum("invoice_items.quantity * invoice_items.unit_price") for invoice_items that have a bulk discount
    #if invoice_item.quantity >= bulk_discount.quantity_threshold
    #invoice_items.sum("quantity * unit_price") 
    # @invoice2.invoice_items.first.discount_invoice_items
    # invoice_items.select("invoice_items.*, sum(invoice_items.quantity* invoice_items.unit_price) as discount_revenue").where("invoice_item.quantity >= bulk_discount.quantity_threshold").group(:id)
    invoice_items.select("invoice_items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue").joins(:bulk_discounts, :discount_invoice_items).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group(:id).sum('revenue * (1- (bulk_discounts.discount/100)')

  end

  def self.unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end
end

# SELECT SUM(invoice_items.quantity * invoice_items.unit_price) FROM "invoice_items" INNER JOIN "discount_invoice_items" ON "discount_invoice_items"."invoice_item_id" = "invoice_items"."id" INNER JOIN "bulk_discounts" ON "bulk_discounts"."id" = "discount_invoice_items"."bulk_discount_id" WHERE "invoice_items"."invoice_id" = $1 AND (transactions.result = 0) AND (invoice_item.quantity >= bulk_discount.quantity_threshold)