# == Schema Information
#
# Table name: borrow_messages
#
#  id                :bigint           not null, primary key
#  body              :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  borrow_request_id :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_borrow_messages_on_borrow_request_id  (borrow_request_id)
#  index_borrow_messages_on_user_id            (user_id)
#
class BorrowMessage < ApplicationRecord
  belongs_to :borrow_request
  belongs_to :user

  validates :borrow_request_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true
end
