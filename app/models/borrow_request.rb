# == Schema Information
#
# Table name: borrow_requests
#
#  id           :bigint           not null, primary key
#  message      :text
#  status       :string           default("pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  book_id      :bigint           not null
#  owner_id     :bigint           not null
#  requester_id :bigint           not null
#
# Indexes
#
#  index_borrow_requests_on_book_id                              (book_id)
#  index_borrow_requests_on_owner_id                             (owner_id)
#  index_borrow_requests_on_requester_id                         (requester_id)
#  index_borrow_requests_on_requester_id_and_book_id_and_status  (requester_id,book_id,status) UNIQUE WHERE ((status)::text = 'pending'::text)
#
class BorrowRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :owner, class_name: "User"
  belongs_to :book

  validates :requester_id, presence: true
  validates :owner_id, presence: true
  validates :book_id, presence: true
  validates :status, presence: true, inclusion: { in: [ "pending", "approved", "denied" ] }
  validate :requester_cannot_be_owner
  validate :only_one_pending_request_per_book

  def requester_cannot_be_owner
    if requester_id.present? && owner_id.present? && requester_id == owner_id
      errors.add(:requester_id, "cannot request their own book")
    end
  end

  def only_one_pending_request_per_book
    if status == "pending" && requester_id.present? && book_id.present?
      matching_requests = BorrowRequest.where({ :requester_id => requester_id, :book_id => book_id, :status => "pending" })

      if id.present?
        matching_requests = matching_requests.where.not({ :id => id })
      end

      if matching_requests.at(0) != nil
        errors.add(:book_id, "already has a pending request from this user")
      end
    end
  end
end
