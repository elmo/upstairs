require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:starts) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  describe 'events' do
    before(:each) do
      load_valid_building
      load_user
      @user.join(@building)
      @valid_attributes = { title: 'title', body: 'body', starts: Time.now, building: @building, user: @user }
    end

    it 'creates notifications' do
      expect { Event.create!(@valid_attributes) }.to change(Notification, :count).by(1)
    end

    describe 'intances methods' do
      before(:each) do
        @event = create(:event, @valid_attributes)
      end

      it 'owned_by?' do
        expect(@event.owned_by?(@user)).to eq true
      end

      it 'has photos' do
        expect(@event).to respond_to(:photos)
      end

      it 'postable' do
        expect(@event.postable).to eq @building
      end
    end

    describe 'commenting on events' do
      before(:each) do
        Notification.any_instance.stub(:deliver_later).and_return(true)
        Event.any_instance.stub(:create_notifications).and_return(true)
        load_valid_building
        load_user
        @event = create(:event, user: @user, building: @building, starts: Time.now)
      end

      it 'creates comment' do
        expect { @event.comments.create(commentable: @event, user: @user, body: 'body') }.to change(Comment, :count).by(1)
      end

      it 'commenters' do
        @event.comments.create(commentable: @event, user: @user, body: 'body')
        expect(@event.commenters.first).to eq @user
        expect(@event.comments.count).to eq 1
        expect(@user.comments.count).to eq 1
      end
    end
  end
end
