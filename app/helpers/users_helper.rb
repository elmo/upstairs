module UsersHelper
  def landlord_link(user:, building:)
    user.landlord_of?(building) ? 'landlord' : ''
  end
end
