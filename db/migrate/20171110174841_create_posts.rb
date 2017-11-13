class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :text
      t.integer :user_id
      t.integer :created_at
    end
  end
end
