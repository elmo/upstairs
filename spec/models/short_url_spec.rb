require 'rails_helper'

RSpec.describe ShortUrl, :type => :model do

  before(:each) do
    SecureRandom.stub(:hex).and_return("138abf8de6")
  end

  it "should create" do
    expect(ShortUrl.for("www.upstairs.io")).to eq "http://test.host/go/138abf8de6"
  end

end
