class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :followees, class_name: 'Follower', foreign_key: :follower_id
  has_many :followers, class_name: 'Follower', foreign_key: :followable_id
  normalizes :email_address, with: ->(e) { e.strip.downcase }


  # rerturn true if self followed by given user
  # otherwise returns false
  #
  def followed?(user)
    return false if user == self
    followers.pluck(:follower_id).include?(user.id)
  end

  #
  #
  def following?(user)
    return false if user == self
    followees.pluck(:followable_id).include?(user.id)
  end

  def follow!(user)
    return false if user == self
    followees.create!(followable_id: user.id)
  end
end
