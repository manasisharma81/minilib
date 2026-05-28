class CreateBorrowRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :borrow_requests do |t|
      t.bigint :requester_id, null: false
      t.bigint :owner_id, null: false
      t.bigint :book_id, null: false
      t.string :status, null: false, default: "pending"
      t.text :message

      t.timestamps
    end

    add_index :borrow_requests, :requester_id
    add_index :borrow_requests, :owner_id
    add_index :borrow_requests, :book_id
    add_index :borrow_requests, [ :requester_id, :book_id, :status ], unique: true, where: "status = 'pending'"
  end
end
