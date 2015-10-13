module VerificationsHelper
  def verified_link(user:, building:)
    user.verified_owner_of?(building) ? 'verified' : 'not verified'
  end
end
