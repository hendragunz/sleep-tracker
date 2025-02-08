require 'rails_helper'

RSpec.describe Follower, type: :model do
  # validations
  describe 'validations' do
    it { should validate_presence_of(:follower) }
    it { should validate_presence_of(:followable) }
  end
end
