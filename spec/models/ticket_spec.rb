require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should have_many(:notifications) }
  it { should have_many(:comments) }

  describe 'Ticket' do
    it 'repsonds to actionable' do
      @ticket = Ticket.new
      expect(@ticket).to respond_to(:actionable)
    end

    it 'repsonds to photos' do
      @ticket = Ticket.new
      expect(@ticket).to respond_to(:photos)
    end

    describe 'bang methods' do
      before(:each) do
        Ticket.any_instance.stub(:create_notifications).and_return(false)
        load_user
        create_valid_ticket
      end

      it 'open!' do
        @ticket.update_attributes(status: Ticket::STATUS_CLOSED)
        expect { @ticket.open! }.to change(@ticket, :status).from(Ticket::STATUS_CLOSED).to(Ticket::STATUS_OPEN)
      end

      it 'close!' do
        @ticket.update_attributes(status: Ticket::STATUS_OPEN)
        expect { @ticket.close! }.to change(@ticket, :status).from(Ticket::STATUS_OPEN).to(Ticket::STATUS_CLOSED)
      end

      it 'escalate!' do
        @ticket.update_attributes(severity: Ticket::SEVERITY_SERIOUS)
        expect { @ticket.escalate! }.to change(@ticket, :severity).from(Ticket::SEVERITY_SERIOUS).to(Ticket::SEVERITY_SEVERE)
      end

      it 'deescalate!' do
        @ticket.update_attributes(severity: Ticket::SEVERITY_SERIOUS)
        expect { @ticket.deescalate! }.to change(@ticket, :severity).from(Ticket::SEVERITY_SERIOUS).to(Ticket::SEVERITY_MINOR)
      end
    end

    describe 'postable'  do
      before(:each) do
        load_valid_building
        load_user
      end

      it 'open' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_SERIOUS, status: Ticket::STATUS_OPEN, title: 'title', body: 'body')
        expect(Ticket.open.first).to eq @ticket
      end

      it 'closed' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_SERIOUS, status: Ticket::STATUS_CLOSED, title: 'title', body: 'body')
        expect(Ticket.closed.first).to eq @ticket
      end

      it 'minor' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_MINOR, status: Ticket::STATUS_OPEN, title: 'title', body: 'body')
        expect(Ticket.minor.first).to eq @ticket
      end

      it 'serious' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_SERIOUS, status: Ticket::STATUS_OPEN, title: 'title', body: 'body')
        expect(Ticket.serious.first).to eq @ticket
      end

      it 'severe' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_SEVERE, status: Ticket::STATUS_OPEN, title: 'title', body: 'body')
        expect(Ticket.severe.first).to eq @ticket
      end

      it 'creates' do
        expect { Ticket.create(building: @building, user: @user, severity:  Ticket::SEVERITY_SEVERE, status: Ticket::STATUS_OPEN, title: 'title', body: 'body') }.to change(Ticket, :count).by(1)
      end

      it 'requires status' do
        expect { Ticket.create(building: @building, user: @user, severity:  Ticket::SEVERITY_SERIOUS, title: 'title') }.to change(Ticket, :count).by(0)
      end

      it 'requires severity' do
        expect { Ticket.create(building: @building, user: @user, status:  Ticket::STATUS_OPEN, title: 'title') }.to change(Ticket, :count).by(0)
      end

      it 'requires title' do
        expect { Ticket.create(building: @building, user: @user, severity:  Ticket::SEVERITY_SEVERE, status: Ticket::STATUS_OPEN) }.to change(Ticket, :count).by(0)
      end

      it 'postable' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_SERIOUS, status: Ticket::STATUS_OPEN)
        expect(@ticket.postable).to eq @building
      end

      it 'owned_by?' do
        @ticket = create(:ticket, building: @building, user: @user, severity:  Ticket::SEVERITY_SERIOUS, status: Ticket::STATUS_OPEN)
        expect(@ticket.owned_by?(@user)).to eq true
      end

      describe 'callbacks' do
        before(:each) do
          Notification.any_instance.stub(:deliver_later).and_return(true)
          @user.join(@building)
        end

        it 'creates notications' do
          expect { Ticket.create(building: @building, user: @user, severity:  Ticket::SEVERITY_SEVERE, status: Ticket::STATUS_OPEN, title: 'title', body: 'body') }.to change(Notification, :count).by(1)
        end

        it 'creates activities' do
          expect { Ticket.create(building: @building, user: @user, severity:  Ticket::SEVERITY_SEVERE, status: Ticket::STATUS_OPEN, title: 'title', body: 'body') }.to change(Activity, :count).by(1)
        end
      end
    end
  end
end
