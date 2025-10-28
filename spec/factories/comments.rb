FactoryBot.define do
  factory :comment do
    content { "遅れます！" }
    association :user
    association :event
  end
end
