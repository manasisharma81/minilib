class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.text :description
      t.string :cover_image_url
      t.integer :rating
      t.text :review
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_index :books, :user_id
  end
end
