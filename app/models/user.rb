class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_secure_password

  before_save { self.email.downcase! }

  validates(:name, { presence: true, length: { maximum: 50 } })
  validates(:email, { presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true })
  validates(:password, { presence: true, length: { minimum: 6 }, allow_nil: true })

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
           : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Defines a proto-feed.
  def feed
    Micropost.where("user_id = ?", self.id)
  end

  # Follows a user.
  def follow(other_user)
    # `<<` appends `other_user` to the end of the `following` ""array""
    # (TECHNICALLY NOT AN ARRAY BUT IT ACTS LIKE AN ARRAY).
    self.following << other_user unless self == other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    self.following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    self.following.include?(other_user)
  end
end
