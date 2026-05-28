# == Schema Information
#
# Table name: user_books
#
#  id         :bigint           not null, primary key
#  rating     :integer
#  review     :text
#  status     :string           default("owned")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_books_on_book_id              (book_id)
#  index_user_books_on_user_id              (user_id)
#  index_user_books_on_user_id_and_book_id  (user_id,book_id) UNIQUE
#
class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, presence: true
  validates :book_id, uniqueness: { scope: :user_id }
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_blank: true
end
