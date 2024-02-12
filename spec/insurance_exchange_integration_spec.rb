require "rails_helper"
require "InsuranceExchangeIntegration"
RSpec.describe InsuranceExchangeIntegration do
  describe ".generate_lead_json_new" do
    let(:lead_id) { 1 }
    let!(:lead) { create(:lead, id: lead_id, first_name: "John", last_name: "Doe") }
    let!(:lead_detail) { create(:lead_detail, lead: lead) }
    it "generates valid JSON" do
      json_data = InsuranceExchangeIntegration.generate_lead_json_new(lead_id)
      expect(json_data).to be_a(Hash)
    end
  end
end
