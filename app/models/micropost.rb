class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image_file
  default_scope -> { order(created_at: :desc) }  # a lambda

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
