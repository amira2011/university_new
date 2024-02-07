require "net/http"
require "uri"
require "json"

module InsuranceExchangeIntegration
  valid_jason_fields = ["contact", "email", "phone", "address", "address_2", "zip", "Home", "home_garage", "home_ownership", "home_length", "interested_in_home_insurance", "interested_in_condo_insurance", "interested_in_life_insurance", "interested_in_renters_insurance", "interested_in_usage_based_policy", "year", "make", "submodel", "vin", "alarm", "primary_purpose", "primary_driver", "average_mileage", "commute_days_per_week", "annual_mileage", "current_mileage", "auto_warranty", "ownership", "collision", "comprehensive", "Drivers", "relationship", "driver", "gender", "marital_status", "birth_date", "first_licensed", "education", "primary_vehicle", "credit_rating", "bankruptcy", "occupation", "good_student", "license_status", "suspended_reason", "license_state", "sr_22", "Incidents", "type", "driver", "incident_date", "description", "what_damaged", "accident_at_fault", "claim_at_fault", "amount_paid", "liability_medical_paid", "dui_state", "Current Policy", "currently_insured", "current_company", "current_customer", "continuous_coverage", "current_policy_expires", "current_policy_premium", "military_affiliation", "Requested Coverage", "coverage_type", "bi_per_person", "bi_per_incident", "Targeting and Auditing", "mediaalpha_certificate_id", "leadid_id", "trusted_form_certificate_id", "score", "call_consent", "sms_consent", "email_consent", "text", "url"]

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

  @mapping = {

    marital_status: {
      "Happily Married" => "Married",
      "Not Married" => "Single",
      "breakup" => "Separated",
      "dissolution" => "Divorced",
    },

  }

  def self.transform_value_without_mapping(value, valid_values)
    valid_values.include?(value) ? value : valid_values.last
  end

  def self.transform_value_with_mapping(value, mapping, valid_values)
    mapped_value = mapping[value] || value
    valid_values.include?(mapped_value) ? mapped_value : valid_values.last
  end

  def self.test
    puts @possible_values.keys
  end

  def InsuranceExchangeIntegration.call_transfer(lead_id)
    data = generate_lead_json(lead_id)

    uri = URI("https://insurance-test.mediaalpha.com/backfill.json")
    req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")

    request_data = {
      api_token: "API",
      placement_id: "Placement",
      version: 17,
      ip: "103.199.192.255",
      local_hour: Time.now.hour,
      url: "www.smartfinancial.com",
      ua: "ubuntu",
      ua_class: "web",
      data: data,
    }
    req.body = request_data.to_json
    Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == "https") do |http|
      response = http.request(req)
      if response.is_a?(Net::HTTPSuccess)
        response = JSON.parse(response.body)
        ads_array = response["ads"] if response.key?("ads")
        num_ads = response["num_ads"].to_i if response.key?("num_ads")
        if num_ads > 0 && ads_array.is_a?(Array)
          # Iterate through each ad in the "ads" array
          ads_array.each do |ad|
            puts "Ad carrier: #{ad["carrier"]}"
            puts "Ad ID: #{ad["ad_id"]}"
            puts "Headline: #{ad["headline"]}"
            puts "Display URL: #{ad["display_url"]}"
          end
        else
          puts "No ads or invalid ads array in the response."
        end
        puts num_ads
        num_ads > 0
      else
        puts "HTTP request failed with status #{response.code}"
        false
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
          "primary_purpose": transform_value_without_mapping(vehicle.primary_purpose, @possible_values[:primary_purpose]),
          "average_mileage": vehicle.average_mileage,
          "commute_days_per_week": vehicle.commute_days_per_week,
          "annual_mileage": vehicle.annual_mileage,
          "ownership": transform_value_without_mapping(vehicle.ownership, @possible_values[:ownership]),
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
          "marital_status": transform_value_with_mapping(driver.marital_status, @mapping[:marital_status], @possible_values[:marital_status]),

        }
      end

      return lead_data
    else
      puts "Lead not found in the database."
    end
  end
end
