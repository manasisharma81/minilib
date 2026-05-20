class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.text :bio
      t.string :profile_picture
      t.datetime :remember_created_at

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
