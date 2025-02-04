require 'rails_helper'

RSpec.describe User, type: :model do
  # validations
  describe 'validations' do
    it { should validate_presence_of(:email_address) }
    it { should validate_presence_of(:name) }
  end
end
