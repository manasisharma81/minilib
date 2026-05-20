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
  devise :database_authenticatable, :registerable,
    :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
