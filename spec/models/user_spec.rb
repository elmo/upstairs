require 'rails_helper'
RSpec.describe User , :type => :model do
  it { should have_many(:activities) }
  it { should have_many(:buildings) }
  it { should have_many(:events) }
  it { should have_many(:invitations) }
  it { should have_many(:memberships) }
  it { should have_many(:notifications) }
  it { should have_many(:replies) }
  it { should belong_to(:invitation) }

  describe "join" do
    before(:each) do
      load_valid_building
      load_user
    end

    it "associates user with a building" do
      expect { @user.join(@building)}.to change(Membership,:count).by(1)
      expect(@user.buildings.first).to eq @building
    end

    it "does not create duplicate membership records" do
      @user.join(@building)
      expect(Membership.count).to eq 1
      expect { @user.join(@building)}.to change(Membership,:count).by(0)
    end
  end

  describe "leave" do
     before(:each) do
       load_membership
     end

    it "dis-associates user with a building" do
      expect { @user.leave(@building)}.to change(Membership,:count).by(-1)
      expect(@user.buildings).to be_empty
    end
  end

  describe "text messages" do
    before(:each) do
      load_user
    end

    it "receives_text_messages? false when ok_to_send_text_messages is false" do
      @user.stub(:ok_to_send_text_messages).and_return(false)
      expect(@user.receives_text_messages?).to eq false
    end

    it "receives_text_messages? false when ok_to_send_text_messages is true and phone_valid? is false"  do
      @user.stub(:ok_to_send_text_messages).and_return(true)
      @user.stub(:phone_valid?).and_return(false)
      expect(@user.receives_text_messages?).to eq false
    end

    it "receives_text_messages? true when ok_to_send_text_messages is true and phone_valid? is true"  do
      @user.stub(:ok_to_send_text_messages).and_return(true)
      @user.stub(:phone_valid?).and_return(true)
      expect(@user.receives_text_messages?).to eq true
    end
  end

  describe "phone_valid?" do
     before(:each) do
       @user = User.new
     end

     it "false when number of digits is 9" do
       @user.phone = "123456789"
       expect(@user.phone_valid?).to eq false
     end

     it "false when number of digits is 13" do
       @user.phone = "1234567890123"
       expect(@user.phone_valid?).to eq false
     end

     it "true when number of digits is 10,11,12" do
       @user.phone = "12345678901"
       expect(@user.phone_valid?).to eq true
       @user.phone = "123456789011"
       expect(@user.phone_valid?).to eq true
       @user.phone = "123456789012"
       expect(@user.phone_valid?).to eq true
     end
  end

  describe "admin?" do
     before(:each) do
       load_user
     end

     it "is false when user does not have role :admin" do
        expect(@user.admin?).to eq false
     end

     it "is true when user has role :admin" do
        @user.add_role(:admin)
        expect(@user.admin?).to eq true
     end
  end

  describe "owns?" do
     before(:each) do
       load_user
       Alert.any_instance.stub(:create_notifications).and_return(true)
     end

      it "is true when user created object" do
        @alert = create(:alert, user: @user)
        expect(@user.owns?(@alert)).to eq true
      end

      it "is true when user created object" do
        @user2 = create(:user, email: "user2@gmail.com")
        @alert = create(:alert, user: @user2)
        expect(@user.owns?(@alert)).to eq false
      end
  end

  describe "public_name" do
     before(:each) do
       load_user
     end

   it "returns username if permitted and present" do
      @user.stub(:use_my_username?).and_return(true)
      @user.username = 'username'
      expect(@user.public_name).to eq 'username'
   end

   it "returns 'anonymous' if not permitted and present" do
      @user.stub(:use_my_username?).and_return(false)
      @user.username = 'username'
      expect(@user.public_name).to eq 'anonymous'
   end

   it "returns 'anonymous' if permitted and blank" do
      @user.stub(:use_my_username?).and_return(false)
      @user.username = 'username'
      expect(@user.public_name).to eq 'anonymous'
   end

  end

  describe "manager_of?" do
     before(:each) do
       load_user
       load_valid_building
     end

   it "is false if user does not have landlord or manager role for building" do
     expect(@user.manager_of?(@building)).to eq false
   end

   it "is true when user has landlord role for building" do
     @user.add_role(:landlord, @building)
     expect(@user.manager_of?(@building)).to eq true
   end

    it "is true when user has manager role for building" do
     @user.add_role(:manager, @building)
     expect(@user.manager_of?(@building)).to eq true
    end
  end

   describe "sent messages" do
     before(:each) do
        load_sent_message
     end

     it "sender has sent message" do
       expect(@sender.sent_messages.first).to eq @message
       expect(@sender.sent_messages_count).to eq 1
     end

     it "recipient has recieved message" do
       expect(@recipient.received_messages.first).to eq @message
       expect(@recipient.received_messages_count).to eq 1
     end

   end

   describe "default_building" do
     before(:each) do
       load_user
       load_valid_building
     end

     it "is nil before user joins building" do
       expect(@user.default_building).to be_nil
     end

     it "is @building after user joins building" do
       @user.join(@building)
       expect(@user.default_building).to eq @building
     end

   end

   describe "apply invitation" do
     before(:each) do
       load_user
       load_valid_building
       @email = "invitee@email.com"
     end

     describe "landlord invitation" do
       before(:each) do
         @invitation = create(:landlord_invitation, user: @user, building: @building, email: @email)
       end
       it "add user to building" do
         @invitee = create(:user, email: @email, invitation: @invitation)
         expect(@invitee.buildings.first).to eq @building
         expect(@invitee.roles.first.name).to eq 'landlord'
       end
     end

     describe "manager invitation" do
       before(:each) do
         @invitation = create(:manager_invitation, user: @user, building: @building, email: @email)
       end

       it "add user to building" do
         @invitee = create(:user, email: @email, invitation: @invitation)
         expect(@invitee.buildings.first).to eq @building
         expect(@invitee.roles.first.name).to eq 'manager'
       end

     end
   end

   describe "to_param" do
      before(:each) do
        @user = create(:user, email: "user@email.com")
      end

      it "should be 10 chars long" do
        expect(@user.to_param.length).to eq 10
        expect(@user.to_param).to eq @user.slug
      end
   end

   describe "landlord?" do
     before(:each) do
       load_valid_building
       load_user
     end

     it "is false when user has no landlord role for bulding" do
       expect(@user.landlord?).to be false
     end

     it "is true when user has landlord role for bulding" do
       @user.add_role('Landlord', @building)
       @user.reload
       expect(@user.landlord?).to be true
     end
   end

   describe "landlord_of_building?" do
     before(:each) do
       load_valid_building
       load_user
     end

     it "is false when user has no landlord role for bulding" do
       expect(@user.landlord_of?(@building)).to be false
     end

     it "is true when user has landlord role for bulding" do
       @user.add_role('Landlord', @building)
       @user.reload
       expect(@user.landlord_of?(@building)).to be true
     end
   end

   describe "owned_properites" do
     before(:each) do
       load_valid_building
       load_user
     end

     it "should be empty when user has no landlord role" do
       expect(@user.owned_properties).to be_empty
     end

     it "should not be empty when user has no landlord role" do
       @user.add_role(User::ROLE_LANDLORD, @building)
       @user.reload
       expect(@user.owned_properties.first).to eq @building
     end

   end

   describe "managed properties" do
     before(:each) do
       load_valid_building
       load_user
     end

     it "should be empty when user has no manager role" do
       expect(@user.managed_properties).to be_empty
     end

     it "should not be empty when user has no manager role" do
       @user.add_role(User::ROLE_MANAGER, @building)
       @user.reload
       expect(@user.managed_properties.first).to eq @building
     end
   end

end
