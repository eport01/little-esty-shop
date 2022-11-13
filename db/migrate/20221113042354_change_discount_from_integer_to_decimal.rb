class ChangeDiscountFromIntegerToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :bulk_discounts, :discount, :decimal, precision: 5, scale: 2
  end
end
