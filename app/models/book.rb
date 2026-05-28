# == Schema Information
#
# Table name: books
#
#  id              :bigint           not null, primary key
#  authors         :string
#  cover_image_url :string
#  description     :text
#  isbn_10         :string
#  isbn_13         :string
#  published_date  :string
#  publisher       :string
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  google_books_id :string           not null
#
# Indexes
#
#  index_books_on_google_books_id  (google_books_id) UNIQUE
#
class Book < ApplicationRecord
  has_many :user_books
  has_many :users, through: :user_books
  has_many :borrow_requests

  validates :google_books_id, presence: true, uniqueness: true
  validates :title, presence: true
end
