class RefactorBooksToGoogleBooksAndUserBooks < ActiveRecord::Migration[8.0]
  def change
    if table_exists?(:borrow_requests)
      execute("DELETE FROM borrow_requests")

      remove_index :borrow_requests,
        name: "index_borrow_requests_on_requester_id_and_book_id_and_status",
        if_exists: true
    end

    if table_exists?(:books)
      execute("DELETE FROM books")

      remove_index :books, name: "index_books_on_user_id", if_exists: true

      remove_column :books, :user_id, :bigint, if_exists: true
      remove_column :books, :author, :string, if_exists: true
      remove_column :books, :rating, :integer, if_exists: true
      remove_column :books, :review, :text, if_exists: true

      add_column :books, :google_books_id, :string, null: false
      add_column :books, :authors, :string
      add_column :books, :isbn_10, :string
      add_column :books, :isbn_13, :string
      add_column :books, :published_date, :string
      add_column :books, :publisher, :string

      add_index :books, :google_books_id, unique: true
    end

    create_table :user_books do |t|
      t.bigint :user_id, null: false
      t.bigint :book_id, null: false
      t.integer :rating
      t.text :review
      t.string :status, default: "owned"

      t.timestamps
    end

    add_index :user_books, :user_id
    add_index :user_books, :book_id
    add_index :user_books, [ :user_id, :book_id ], unique: true

    if table_exists?(:borrow_requests)
      add_index :borrow_requests,
        [ :requester_id, :owner_id, :book_id, :status ],
        unique: true,
        where: "status = 'pending'",
        name: "index_pending_borrow_requests_unique_owner_book"
    end
  end
end
