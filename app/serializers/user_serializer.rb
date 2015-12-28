class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :phone, :use_my_username, :ok_to_send_text_messages, :slug, :invitation_id, :created_at, :updated_at, :provider, :uid, :profile_status
end
