class CreateBorrowMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :borrow_messages do |t|
      t.bigint :borrow_request_id, null: false
      t.bigint :user_id, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :borrow_messages, :borrow_request_id
    add_index :borrow_messages, :user_id
  end
end
