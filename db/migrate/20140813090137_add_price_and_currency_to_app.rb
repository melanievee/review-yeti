class AddPriceAndCurrencyToApp < ActiveRecord::Migration
  def change
  	add_column :apps, :price, :float
  	add_column :apps, :currency, :string
  end
end
