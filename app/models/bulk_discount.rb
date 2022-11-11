class BulkDiscount < ApplicationRecord
  belongs_to :merchant 
  has_many :discount_items
  has_many :items, through: :discount_items 
end