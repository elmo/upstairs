json.array!(@manager_invitations) do |manager_invitation|
  json.extract! manager_invitation, :id
  json.url manager_invitation_url(manager_invitation, format: :json)
end
