class Follower < ApplicationRecord
  belongs_to :followable, foreign_key: :followable_id, class_name: 'User'
  belongs_to :follower, foreign_key: :follower_id, class_name: 'User'
end
