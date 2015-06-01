class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :usertype, :string, default: :beta
  end
end
