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

 

  def discount_revenue #returns invoice item
    #tables: invoice_items, bulk_discounts 

    # invoice_items.select("invoice_items.*, sum(invoice_items.quantity* invoice_items.unit_price) as discount_revenue").where("invoice_item.quantity >= bulk_discount.quantity_threshold").group(:id)
    # invoice_items.select("invoice_items.*, sum(invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.discount)) as revenue").joins(:bulk_discounts, :discount_invoice_items).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group(:id)
    invoice_items.joins(:bulk_discounts, :discount_invoice_items).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").sum("invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.discount)").to_i

    #@invoice2.discount_revenue.first.revenue.to_i

  end

  def self.unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end
end

# SELECT SUM(invoice_items.quantity * invoice_items.unit_price) FROM "invoice_items" INNER JOIN "discount_invoice_items" ON "discount_invoice_items"."invoice_item_id" = "invoice_items"."id" INNER JOIN "bulk_discounts" ON "bulk_discounts"."id" = "discount_invoice_items"."bulk_discount_id" WHERE "invoice_items"."invoice_id" = $1 AND (transactions.result = 0) AND (invoice_item.quantity >= bulk_discount.quantity_threshold)