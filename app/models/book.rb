# == Schema Information
#
# Table name: books
#
#  id              :bigint           not null, primary key
#  author          :string           not null
#  cover_image_url :string
#  description     :text
#  rating          :integer
#  review          :text
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_books_on_user_id  (user_id)
#
class Book < ApplicationRecord
  belongs_to :user
  has_many :borrow_requests

  validates :title, presence: true
  validates :author, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_blank: true
end
