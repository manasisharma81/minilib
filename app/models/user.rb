# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  bio                 :text
#  email               :string           default(""), not null
#  encrypted_password  :string           default(""), not null
#  profile_picture     :string
#  remember_created_at :datetime
#  username            :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  has_many :user_books
  has_many :books, through: :user_books
  has_many :incoming_borrow_requests, class_name: "BorrowRequest", foreign_key: "owner_id"
  has_many :outgoing_borrow_requests, class_name: "BorrowRequest", foreign_key: "requester_id"
  has_many :borrow_messages

  devise :database_authenticatable, :registerable,
    :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
