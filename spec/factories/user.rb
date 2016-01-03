FactoryGirl.define do
  factory :user do
    password '123mainstreet!'
    password_confirmation '123mainstreet!'
    username 'username'
    phone '6175551212'
    use_my_username true
    ok_to_send_text_messages true
    slug 'user-slug'
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
