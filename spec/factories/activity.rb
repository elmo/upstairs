FactoryGirl.define do
  factory :activity do
    association :user, factory: :user
    association :builiding, factory: :building
  end
end
