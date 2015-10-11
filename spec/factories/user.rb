FactoryGirl.define do
  factory :user do
    password '123mainstreet!'
    password_confirmation '123mainstreet!'
  end

  factory :verifier, class: 'User' do
    password '123mainstreet!!'
    password_confirmation '123mainstreet!!'
    email "#{SecureRandom.hex(4)}-user@email.com"
  end

  factory :landlord, class: 'User' do
    password '123mainstreet!!!'
    password_confirmation '123mainstreet!!!'
    email "#{SecureRandom.hex(4)}-user@email.com"
  end
end
