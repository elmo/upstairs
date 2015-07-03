FactoryGirl.define do
  factory :landlord_invitation do
    type 'LandlordInvitation'
  end

  factory :manager_invitation do
    type 'ManagerInvitation'
  end

  factory :user_invitation do
    type 'UserInvitation'
  end

end
