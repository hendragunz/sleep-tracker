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
end
