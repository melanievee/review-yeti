class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :app_id
      t.datetime :updated
      t.string :title
      t.text :content
      t.integer :votesum
      t.integer :votecount
      t.integer :rating
      t.string :version
      t.string :author
      t.string :author_uri

      t.timestamps
    end
    add_index :reviews, :version
    add_index :reviews, :app_id
  end
end
