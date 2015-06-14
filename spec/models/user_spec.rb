require 'rails_helper'
RSpec.describe User , :type => :model do
  it { should have_many(:memberships) }
  it { should have_many(:communities) }

  describe "join" do
    before(:each) do
      load_user_and_building
    end

    it "associates user with a building" do
      expect { @user.join(@building)}.to change(Membership,:count).by(1)
      expect(@user.communities.first).to eq @building
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
      expect(@user.communities).to be_empty
    end
  end
end
