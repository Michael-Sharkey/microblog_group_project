class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :location
      t.integer :age
      t.string :petpeeves

    end
  end
end
