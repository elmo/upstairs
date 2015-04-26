require 'rails_helper'

RSpec.describe "tickets/show", :type => :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      :user_id => 1,
      :community_id => 2,
      :title => "Title",
      :body => "MyText",
      :severity => 3,
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Status/)
  end
end
