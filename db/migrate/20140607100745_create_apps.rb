class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :itunesid
      t.string :name
      t.string :artist

      t.timestamps
    end
  end
end
