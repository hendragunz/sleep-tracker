require 'rails_helper'

describe Simple::V1::Follows, type: :request do
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

  describe "GET /api/v1/follows" do
    context 'with user has followees data'  do
      before {
        create_list(:follower, 5, follower: user)
        create_list(:follower, 3, follower: other_user)
      }

      it 'should return all followees' do
        get "/api/v1/follows", headers: headers, as: :json

        expect(parsed_json['follows'].size).to eq(5)
        expect(response.code).to eq("200")
      end
    end

    context 'with user has no followings'  do
      it 'should return empty_array' do
        get "/api/v1/follows", headers: headers, as: :json

        expect(parsed_json['follows'].size).to eq(0)
        expect(response.code).to eq("200")
      end
    end
  end

  describe "POST /api/v1/follows" do
    let(:target_user1) { create(:user) }
    let(:target_user2) { create(:user) }

    let(:api_params) {
      {
        user: {
          email_address: target_user1.email_address
        }
      }
    }

    it "should follow target_user1 properly" do
      expect {
        post "/api/v1/follows", headers: headers, params: api_params, as: :json
      }.to change{ user.followees.count }.by(1)

      expect(parsed_json['follow']['email_address']).to eq(target_user1.email_address)
      expect(response.code).to eq("201")
    end
  end
end
