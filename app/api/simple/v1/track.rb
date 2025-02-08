module Simple
  class V1::Track < Grape::API

    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resource :track do
      desc "Track time when go to sleep"
      post "/sleep" do

      end

      desc "Track time when wake u "
      post "/wakeup" do

      end
    end
  end
end
