class AddImageurlToApp < ActiveRecord::Migration
  def change
  	add_column :apps, :imageurl, :string
  end
end