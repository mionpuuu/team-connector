FactoryBot.define do
  factory :event do
    association :user
    title { "練習試合" }
    date { Date.today + 7 }
    location { "渋谷体育館" }
    description { "渋谷体育館で練習試合を行います。" }
  end
end
