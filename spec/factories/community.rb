FactoryGirl.define do
  factory :community do
    name  "The Big Pink Building"
    address_line_one "123 Main Street"
    address_line_two "Apt. 1"
    city "San Francisco"
    state "CA"
    postal_code  "94121"
    status true
  end
end
