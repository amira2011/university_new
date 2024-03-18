require "json"
require "net/http"

module InsuranceExchangeIntegration
  def self.call_transfer(lead_id)
    begin
      # Generate JSON data for the lead
      data = generate_lead_json(lead_id)

      # Specify the target URI
      uri = URI("https://insurance-test.mediaalpha.com/backfill.json")

      # Create a new POST request with the specified headers
      req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")

      # Define request data including API token, placement ID, version, IP, etc.
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

      # Set the request body with the JSON representation of the request data
      req.body = request_data.to_json

      # Make the HTTP request
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        response = http.request(req)

        # Check if the request was successful
        if response.is_a?(Net::HTTPSuccess)
          # Parse the response JSON
          response_data = JSON.parse(response.body)

          # Extract information from the response, such as ads
          ads_array = response_data["ads"] if response_data.key?("ads")
          num_ads = response_data["num_ads"].to_i if response_data.key?("num_ads")

          # Process and display information about ads if available
          if num_ads > 0 && ads_array.is_a?(Array)
            ads_array.each do |ad|
              puts "Ad carrier: #{ad["carrier"]}"
              puts "Ad ID: #{ad["ad_id"]}"
              puts "Headline: #{ad["headline"]}"
              puts "Display URL: #{ad["display_url"]}"
            end
          else
            puts "No ads or invalid ads array in the response."
          end

          # Return true if there are ads, indicating a successful response
          puts num_ads
          return num_ads > 0
        else
          # Display an error message if the HTTP request failed
          puts "HTTP request failed with status #{response.code}"
          return false
        end
      end
    rescue JSON::ParserError => e
      puts "Error parsing JSON response: #{e.message}"
      return false
    rescue StandardError => e
      puts "An unexpected error occurred: #{e.message}"
      return false
    end
  end
end
