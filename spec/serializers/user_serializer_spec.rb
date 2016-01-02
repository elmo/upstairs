require 'rails_helper'
RSpec.describe UserSerializer, type: :serializer do
  describe 'attributes' do

    before(:each) do
      load_user
      @user_serializer = UserSerializer.new(@user)
    end

    it "email" do
      expect(@user_serializer.email).to eq @user.email
    end

    it "username" do
      expect(@user_serializer.username).to eq @user.username
    end

    it "phone" do
      expect(@user_serializer.phone).to eq @user.phone
    end

    it "use_my_username" do
      expect(@user_serializer.use_my_username).to eq @user.use_my_username
    end

    it "ok_to_send_text_messages" do
      expect(@user_serializer.ok_to_send_text_messages).to eq @user.ok_to_send_text_messages
    end

    it "slug" do
      expect(@user_serializer.slug).to eq @user.slug
    end

    it "invitation_id" do
      expect(@user_serializer.invitation_id).to eq @user.invitation_id
    end

    it "profile_status" do
      expect(@user_serializer.profile_status).to eq @user.profile_status
    end

  end
end
