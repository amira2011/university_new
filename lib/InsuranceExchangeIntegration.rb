require "net/http"
require "uri"
require "json"

module InsuranceExchangeIntegration
  @possible_values = {
    primary_purpose: ["Business", "Commute School", "Commute Varies", "Commute Work", "Farm", "Government", "Pleasure", "Other"],
    ownership: ["finance", "lease", "own", "other"],
    collision: ["50", "100", "250", "500", "1000", "2500"],
    comprehensive: ["50", "100", "250", "500", "1000", "2500"],
    relationship: ["self", "spouse", "parent", "sibling", "child", "grandparent", "grandchild", "domestic partner", "other"],
    gender: ["M", "F", "X"],
    marital_status: ["Single", "Married", "Divorced", "Separated", "Widowed", "Domestic Partner", "Unknown"],
    education: ["None", "High School", "GED", "Incomplete", "Some College", "Vocational", "Associate", "Bachelor", "Master", "PhD", "Law", "Unknown", "Other Nonprofessional Degree", "Other Professional Degree"],
    credit_rating: ["Excellent", "Good", "Average", "Below average", "Poor"],
    occupation: ["Job1", "Job2", "Job3"],
    license_status: ["Active", "Expired", "International", "Learner", "None", "Other", "Permit", "Probation", "Restricted", "Revoked", "Suspended", "Temporary"],
    suspended_reason: ["Failure to pay ticket", "DUI", "Received too many tickets", "No insurance", "Other"],
    incident_type: ["ticket", "dui", "accident", "claim", "suspension"],
  }

  def InsuranceExchangeIntegration.set_field_value(field, value)
    if @possible_values.key?(field.to_sym)
      if @possible_values[field.to_sym].include?(value)
        value
      else
        "Other"
      end
    end
  end

  def InsuranceExchangeIntegration.call_transfer(lead_id)
    data = generate_lead_json(lead_id)
    request_data = {
      api_token: "API",
      placement_id: "placement_id",
      version: 17,
      call_type: "Inbound",
      local_hour: Time.now.hour,
      url: "www.smartfinancial.com",
      ua_class: "web",
      data: data,
    }
    uri = URI("https://insurance-test.mediaalpha.com/call-transfers.json")
    req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
    req.body = request_data.to_json
    puts req.body
    Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == "https") do |http|
      response = http.request(req)
      if response.is_a?(Net::HTTPSuccess)
        response = JSON.parse(response.body)
        puts response
        call_transfers = response["call_transfers"] if response.key?("call_transfers")

        !call_transfers.nil? && call_transfers.length > 0
      else
        puts "HTTP request failed with status #{response.code}"
      end
    end
  end

  def InsuranceExchangeIntegration.generate_lead_json(lead_id)
    lead = Lead.includes(:lead_detail, :lead_drivers, :lead_vehicles, :lead_violations).find_by(id: lead_id)
    puts lead
    if lead
      lead_data = {
        "address": lead.address,
        "address_2": lead.address2,
        "continuous_coverage": lead.lead_detail.continuous_coverage,
        "zip": lead.zip,
        "current_company": lead.lead_detail.current_company,
        "current_customer": lead.lead_detail.current_customer,
        "currently_insured": lead.lead_detail.currently_insured,
        "vehicles": [],
        "drivers": [],
        "email": lead.email,
        "home_garage": lead.lead_detail.home_garage,
        "home_length": lead.lead_detail.home_length,
        "home_ownership": lead.lead_detail.home_owner,
        "incidents": [],
        "interested_in_condo_insurance": lead.lead_detail.interested_in_condo_insurance,
        "interested_in_home_insurance": lead.lead_detail.interested_in_home_insurance,
        "interested_in_life_insurance": lead.lead_detail.interested_in_life_insurance,
        "interested_in_renters_insurance": lead.lead_detail.interested_in_renters_insurance,
        "interested_in_usage_based_policy": lead.lead_detail.interested_in_usage_based_policy,
        "leadid_id": lead.id,
        "military_affiliation": lead.lead_detail.military_affiliation,
        "phone": lead.phone,
        "zip": lead.zip,
      }

      # Populate 'vehicles' array
      lead.lead_vehicles.each do |vehicle|
        lead_data[:vehicles] << {
          "year": vehicle.year,
          "make": vehicle.make,
          "model": vehicle.model,
          "submodel": vehicle.submodel,
          "vin": vehicle.vin,
          "alarm": vehicle.alarm,
          "primary_purpose": vehicle.primary_purpose,
          "average_mileage": vehicle.average_mileage,
          "commute_days_per_week": vehicle.commute_days_per_week,
          "annual_mileage": vehicle.annual_mileage,
          "ownership": vehicle.ownership,
          "collision": vehicle.ownership,
          "comprehensive": vehicle.ownership,
        }
      end

      # Populate 'drivers' array
      lead.lead_drivers.each do |driver|
        lead_data[:drivers] << {
          "bankruptcy": driver.bankruptcy,
          "birth_date": driver.birth_date,
          "credit_rating": driver.credit_rating,
          "driver": "#{driver.first_name} #{driver.last_name}",

        }
      end

      return lead_data
    else
      puts "Lead not found in the database."
    end
  end
end
