class AddEmailOptinToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :gets_emails, :boolean
  end
end
