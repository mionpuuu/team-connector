FactoryBot.define do
  factory :notice do
    title { "集金のお知らせ" }
    content { "部費を何日に集金します。" }
    association :user
  end
end
