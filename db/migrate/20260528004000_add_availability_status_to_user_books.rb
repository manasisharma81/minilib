class AddAvailabilityStatusToUserBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :user_books, :availability_status, :string
  end
end
