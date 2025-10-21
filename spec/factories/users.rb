FactoryBot.define do
  factory :user do
    username              { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { "abc123" }
    password_confirmation { password }
  end
end
