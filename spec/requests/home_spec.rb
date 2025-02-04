require 'rails_helper'

RSpec.describe "Home", type: :request do
  let(:user) { create(:user) }

  describe "GET /show" do
    context 'with no login' do
      it 'should redirected to login page' do
        get '/'
        expect(response).to redirect_to("/session/new")
      end
    end

    context 'with logged in' do
      before {
        post session_path, params: { email_address: user.email_address, password: "password" }
      }

      it 'should render successfully' do
        get '/'
        expect(response).to have_http_status(:ok)
        expect(response).to render_template("show")
      end
    end
  end
end
