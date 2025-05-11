# README

Test App challenges for tracking sleep from followees. 

# Tech Stacks

* Ruby 3.3.6
* Rails 8
* Postgres
* Sidekiq (for handling follow/unfollow and record sleep acitivities)

# Test challenges 

1. Clock In operation, and return all clocked-in times, ordered by created time.
   - POST `/v1/api/track/sleep` (for start to sleep)
   - POST `/v1/api/track/wakeup` (for wakeup and must be sleep first) 

2. Users can follow and unfollow other users.
   - POST `/v1/api/follows` (to follow user)
   - DELETE `/v1/api/follows` (to unfollow user)

3. See the sleep records of a user's All following users' sleep records. from the previous week, which are sorted based on the duration of All friends sleep length.
   - GET `/v1/api/sleep_logs/me` (this is to pull sleep activities from current user
   - GET `/v1/api/sleep_logs/followees` (this is to pull sleep activities from followees
   - GET `/v1/api/sleep_logs/followees/last_week` (this is to pull sleep activities from followees but specific for last week / less than 7 days)

# RSpec

To check the rspec, just need to run `$ bundle exec rspec spec`
Coverage can be found in folder `/coverage`
