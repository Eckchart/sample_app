class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image_file do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) }  # a lambda

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image_file,
    content_type: {
      in: %w[image/jpeg image/gif image/png], 
      message: "must be a valid image format"
    },
    size: {
      less_than: 5.megabytes,
      message: "should be less than 5MB"
    }
end
