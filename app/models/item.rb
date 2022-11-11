class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant 
  has_many :transactions, through: :invoices 
  has_many :discount_items
  has_many :bulk_discounts, through: :discount_items 

  def most_recent_date
    invoices.order(created_at: :desc).limit(1).pluck(:created_at)
  end
end