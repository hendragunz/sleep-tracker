FactoryBot.define do
  factory :user do
    sequence(:email_address)  { |n| "user-#{n+1}@example.com" }
    name                      { FFaker::Name.name }
    password_digest           { BCrypt::Password.create("password") }
  end
end
