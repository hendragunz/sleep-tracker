# this job to process user to follow / unfollow the target user
# and it must be unique
# So.. in one time, only one job exist per user per target followee
#
class FollowUnfollowJob
  include Sidekiq::Job

  sidekiq_options queue: "critical",
                  lock: :until_executed

  def perform(user_id, followee_email)
    user = User.find(user_id)
    target_followee = User.find_by(email_address: followee_email)

    if target_followee
      if user.following?(target_followee)
        user.unfollow(target_followee)
      else
        user.follow(target_followee)
      end
    end
  end
end
