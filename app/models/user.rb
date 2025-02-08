class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :followees, class_name: 'Follower', foreign_key: :follower_id
  has_many :followers, class_name: 'Follower', foreign_key: :followable_id
  has_many :sleep_logs
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true
  validates :name, presence: true


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

  def follow(user)
    return false if user == self
    followees.find_or_create_by(followable_id: user.id)
  end

  # a simple method to generate authentication token
  # for API access
  #
  def generate_authentication_token!
    update!(authentication_token: SecureRandom.urlsafe_base64(nil, false))
  end


  def sleep?
    last_sleep_log = sleep_logs.latest.first
    return false if last_sleep_log.nil?
    last_sleep_log && last_sleep_log.sleep_at.present? && last_sleep_log.wakeup_at.blank?
  end

  def awake?
    last_sleep_log = sleep_logs.latest.first
    return true if last_sleep_log.nil?
    last_sleep_log && last_sleep_log.sleep_at.present? && last_sleep_log.wakeup_at.present?
  end
end
