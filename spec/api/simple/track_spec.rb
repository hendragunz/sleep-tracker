require 'rails_helper'

describe Simple::V1::Track, type: :request do
  let!(:user)       { create(:user) }

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

  describe "POST /api/v1/track/sleep" do
    context 'with user has not sleep yet'  do
      it 'should record the sleep_at properly' do
        expect {
          post "/api/v1/track/sleep", headers: headers, as: :json
        }.to change{ user.sleep_logs.count }.by(1)

        expect(parsed_json['sleep_log']['sleep_at']).to be_present
        expect(parsed_json['sleep_log']['wakeup_at']).not_to be_present
        expect(response.code).to eq("201")
      end
    end

    context 'with user already sleep'  do
      before {
        user.sleep_logs.create(sleep_at: 3.hours.ago)
      }

      it 'should record the sleep_at properly' do
        expect {
          post "/api/v1/track/sleep", headers: headers, as: :json
        }.to change{ user.sleep_logs.count }.by(0)

        expect(parsed_json['error']).to eq("You can't sleep while you already sleeping :-) ")
        expect(response.code).to eq("404")
      end
    end
  end

  describe "POST /api/v1/track/wakeup" do
    context 'with user has been sleep'  do
      before {
        user.sleep_logs.create(sleep_at: 3.hours.ago)
      }

      it 'should record the wakeup properly' do
        expect {
          post "/api/v1/track/wakeup", headers: headers, as: :json
        }.to change{ user.sleep_logs.count }.by(0)

        expect(parsed_json['sleep_log']['sleep_at']).to be_present
        expect(parsed_json['sleep_log']['wakeup_at']).to be_present
        expect(response.code).to eq("201")
      end
    end

    context 'with user not sleep yet'  do
      it 'should return error message' do
        expect {
          post "/api/v1/track/wakeup", headers: headers, as: :json
        }.to change{ user.sleep_logs.count }.by(0)

        expect(parsed_json['error']).to eq("You didn't sleep yet :-) ")
        expect(response.code).to eq("404")
      end
    end
  end
end
