require 'rails_helper'

describe Simple::V1::SleepLogs, type: :request do
  let!(:user)       { create(:user) }
  let(:other_user)  { create(:user) }

  # to generate the authentication token
  # must hit this method once
  #
  before {
    user.generate_authentication_token!
  }

  let(:headers) {
    {
      'access-token' => user.authentication_token
    }
  }

  describe "GET /api/v1/sleep_logs/me" do
    # create sleep logs for this week
    before {
      [ 5, 4, 3, 2, 1 ].each do |day_ago|
        sleep_at = day_ago.days.ago
        wakeup_at = sleep_at + (1..5).to_a.sample.hours

        user.sleep!(sleep_at)
        UserWakeUpJob.new.perform(user.id, wakeup_at.to_i)
      end
    }

    it "should return all current user sleep logs" do
      get "/api/v1/sleep_logs/me", headers: headers, as: :json

      expect(parsed_json['sleep_logs'].size).to eq(5)
      expect(response.code).to eq("200")
    end

    context "with params from_date and end_date" do
      let(:to_date)     { DateTime.now }
      let(:from_date)   { to_date - 7.day }
      let(:api_params)  {
        {
          from_date: from_date.to_date.to_s,
          to_date: to_date.to_date.to_s
        }
      }

      # let's create user sleep logs first from previous week too
      before {
        [ 13, 12, 11, 10, 9 ].each do |day_ago|
          sleep_at = day_ago.days.ago
          wakeup_at = sleep_at + (1..5).to_a.sample.hours

          user.sleep!(sleep_at)
          UserWakeUpJob.new.perform(user.id, wakeup_at.to_i)
        end
      }

      it "should return current user logs with specific date range" do
        expect(user.sleep_logs.size).to eq(10)

        get "/api/v1/sleep_logs/me?#{CGI.unescape(api_params.to_query)}", headers: headers, as: :json
        expect(parsed_json['sleep_logs'].size).to eq(5)
        expect(parsed_json['sleep_logs'].first['sleep_at']).to be >= from_date
        expect(parsed_json['sleep_logs'].first['sleep_at']).to be <= to_date
      end
    end
  end

  describe "GET /api/v1/sleep_logs/followees" do
    let(:target_user1) { create(:user) }
    let(:target_user2) { create(:user) }

    before {
      [ target_user1, target_user2 ].each do |target_user|
        user.follow(target_user)

        [ 5, 4, 3, 2, 1 ].each do |day_ago|
          sleep_at = day_ago.days.ago
          wakeup_at = sleep_at + (1..5).to_a.sample.hours

          target_user.sleep!(sleep_at)
          UserWakeUpJob.new.perform(target_user.id, wakeup_at.to_i)
        end
      end
    }

    it "should return all followees sleep logs" do
      get "/api/v1/sleep_logs/followees", headers: headers, as: :json

      expect(parsed_json['sleep_logs'].size).to eq(10)
      expect(response.code).to eq("200")

      parsed_emails = parsed_json['sleep_logs'].map { |log| log['user']['email_address'] }
      expect(parsed_emails).to include(target_user1.email_address)
      expect(parsed_emails).to include(target_user2.email_address)
    end

    context "with params from_date and end_date" do
      let(:to_date)     { 1.week.ago }
      let(:from_date)   { to_date - 7.day }
      let(:api_params)  {
        {
          from_date: from_date.to_date.to_s,
          to_date: to_date.to_date.to_s
        }
      }

      # let's create user sleep logs first from previous week too
      before {
        [ 13, 12, 11, 10, 9 ].each do |day_ago|
          sleep_at = day_ago.days.ago
          wakeup_at = sleep_at + (1..5).to_a.sample.hours

          target_user1.sleep!(sleep_at)
          UserWakeUpJob.new.perform(target_user1.id, wakeup_at.to_i)
        end
      }

      it "should return followees sleep logs with specific date range" do
        get "/api/v1/sleep_logs/followees?#{CGI.unescape(api_params.to_query)}", headers: headers, as: :json

        expect(parsed_json['sleep_logs'].size).to eq(5)
        expect(parsed_json['sleep_logs'].first['sleep_at']).to be >= from_date
        expect(parsed_json['sleep_logs'].first['sleep_at']).to be <= to_date

        parsed_emails = parsed_json['sleep_logs'].map { |log| log['user']['email_address'] }
        expect(parsed_emails).to include(target_user1.email_address)
        expect(parsed_emails).to_not include(target_user2.email_address)
      end
    end
  end

  describe "GET /api/v1/sleep_logs/followees/last_week" do
    let(:target_user1) { create(:user) }
    let(:target_user2) { create(:user) }
    let(:target_user3) { create(:user) }

    let(:target_user1) { create(:user) }
    let(:target_user2) { create(:user) }

    before {
      # sleep logs data for last week
      [ target_user3 ].each do |target_user|
        user.follow(target_user)

        [ 5, 4, 3, 2, 1 ].each do |day_ago|
          sleep_at = day_ago.days.ago
          wakeup_at = sleep_at + (1..5).to_a.sample.hours

          target_user.sleep!(sleep_at)
          UserWakeUpJob.new.perform(target_user.id, wakeup_at.to_i)
        end
      end

      # sleep logs data for previous week
      [ target_user1, target_user2 ].each do |target_user|
        user.follow(target_user)

        [ 13, 12, 11, 10, 9 ].each do |day_ago|
          sleep_at = day_ago.days.ago
          wakeup_at = sleep_at + (1..5).to_a.sample.hours

          target_user.sleep!(sleep_at)
          UserWakeUpJob.new.perform(target_user.id, wakeup_at.to_i)
        end
      end
    }

    it "should return all followees sleep logs for last week" do
      get "/api/v1/sleep_logs/followees/last_week", headers: headers, as: :json

        expect(parsed_json['sleep_logs'].size).to eq(5)
        expect(parsed_json['sleep_logs'].first['sleep_at']).to be >= 7.days.ago # not more than 7 days ago

        parsed_emails = parsed_json['sleep_logs'].map { |log| log['user']['email_address'] }
        expect(parsed_emails).not_to include(target_user1.email_address) # we have sleep logs data for this user but for previous week
        expect(parsed_emails).to_not include(target_user2.email_address) # we have sleep logs data for this user but for previous week
        expect(parsed_emails).to include(target_user3.email_address) # only this user
    end
  end
end
