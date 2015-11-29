require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }
  it { should belong_to(:building) }
  it { should validate_presence_of(:sender).with_message("can't be blank") }
  it { should validate_presence_of(:recipient).with_message("can't be blank") }
  it { should validate_presence_of(:building).with_message("can't be blank") }
  it { should validate_presence_of(:body).with_message('Your message is empty.') }

  describe 'Message' do
    before(:each) do
      load_valid_building
      @sender = create(:user, email: "#{SecureRandom.hex(5)}-@email.com")
      @recipient = create(:user, email: "#{SecureRandom.hex(5)}-@email.com")
      @valid_attributes = { sender: @sender, recipient: @recipient, building: @building, body: 'message body' }
    end

    it 'creates' do
      expect { Message.create!(@valid_attributes) }.to change(Message, :count).by(1)
    end

    it 'creates notifications' do
      expect { Message.create!(@valid_attributes) }.to change(Notification, :count).by(1)
    end

    describe 'instance methods' do
      before(:each) do
        @message = Message.create(@valid_attributes)
      end

      it 'slug' do
        expect(@message.slug).to_not be_blank
      end

      it 'slug' do
        expect(@message.to_param).to eq @message.slug
      end
    end
  end

  describe "user messages" do
     before(:each) do
       load_valid_building
       @sender = create(:user, email: "#{SecureRandom.hex(5)}-@email.com")
       @recipient = create(:user, email: "#{SecureRandom.hex(5)}-@email.com")
       @valid_attributes = { sender: @sender, recipient: @recipient, building: @building, body: 'message body' }
     end

     it "changes sender sent counts" do
       expect { Message.create!(@valid_attributes) }.to change(@sender, :sent_messages_count).by(1)
     end

     it "changes recipient recieved count" do
       expect { Message.create!(@valid_attributes) }.to change(@recipient, :received_messages_count).by(1)
     end

     it "changes recipient recieved count" do
       expect { Message.create!(@valid_attributes) }.to change(@recipient, :has_unread_messages?).from(false).to(true)
     end
  end
end
