class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, presence: true
  validates :book_id, uniqueness: { scope: :user_id }
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_blank: true
end
