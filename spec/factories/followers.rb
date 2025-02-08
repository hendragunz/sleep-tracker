FactoryBot.define do
  factory :follower do
    association :followable,  factory: :user
    association :follower,    factory: :user
  end
end
