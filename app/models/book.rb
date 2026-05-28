class Book < ApplicationRecord
  has_many :user_books
  has_many :users, through: :user_books
  has_many :borrow_requests

  validates :google_books_id, presence: true, uniqueness: true
  validates :title, presence: true
end
