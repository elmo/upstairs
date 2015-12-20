FactoryGirl.define do
  factory :post do
    title 'a sample title'
    body 'a sample body'
    association :category
  end
end
