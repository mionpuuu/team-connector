FactoryBot.define do
  factory :attendance do
    association :user
    association :event
    status { :attending }
  end
end
