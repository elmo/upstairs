require 'rails_helper'
RSpec.describe TicketSerializer, type: :serializer do
  describe 'attributes' do

    before(:each) do
      Ticket.any_instance.stub(:create_notifications).and_return(false)
      load_user
      create_valid_ticket
      @ticket_serializer = TicketSerializer.new(@ticket)
    end

    it "id" do
      expect(@ticket_serializer.id).to eq @ticket.id
    end

    it "user_id" do
      expect(@ticket_serializer.user_id).to eq @ticket.user_id
    end

    it "building_id" do
      expect(@ticket_serializer.building_id).to eq @ticket.building_id
    end

    it "title" do
      expect(@ticket_serializer.title).to eq @ticket.title
    end

    it "body" do
      expect(@ticket_serializer.body).to eq @ticket.body
    end

    it "severity" do
      expect(@ticket_serializer.severity).to eq @ticket.severity
    end

    it "status" do
      expect(@ticket_serializer.status).to eq @ticket.status
    end

    it "created_at" do
      expect(@ticket_serializer.created_at).to eq @ticket.created_at
    end

    it "updated_at" do
      expect(@ticket_serializer.updated_at).to eq @ticket.updated_at
    end
  end
end
