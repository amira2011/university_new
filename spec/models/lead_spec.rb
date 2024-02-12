require "rails_helper"

RSpec.describe Lead, type: :model do
  it "Returns Full Name for a User" do
    lead = Lead.create(first_name: "Abid", last_name: "Shaikh")
    expect(lead.contact).to eq "Abid Shaikh"
  end
end
