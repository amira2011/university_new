require 'net/http'
require 'uri'
require 'json'

module InsuranceExchangeIntegration

   

    def InsuranceExchangeIntegration.call_transfer(lead_id)

        api_token = "API" 
        placement_id = "ID"
        data = generate_lead_json(lead_id)
        request_data = {
            api_token: api_token,
            placement_id: placement_id, 
            version: 17,
            call_type: "Inbound",
            local_hour: Time.now.hour, 
            url: "www.smartfinancial.com",
            ua_class: 'web', 
            data: data.to_json
        }
         
        puts request_data
        uri = URI.parse("https://insurance-test.mediaalpha.com/call-transfers.json")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
      
        request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
        request.body = request_data.to_json
      
        begin
            response = http.request(request)
          
            if response.is_a?(Net::HTTPSuccess)
                response = JSON.parse(response.body)
                puts response
                call_transfers = response['call_transfers'] if response.key?('call_transfers')
        
                !call_transfers.nil? && call_transfers.length > 0
            else
              puts "HTTP request failed with status #{response.code}"
              
            end
          rescue StandardError => e
            puts "An error occurred: #{e.message}"
             
          end


         
       
      
    end


    






    def InsuranceExchangeIntegration.generate_lead_json(lead_id)
      
      lead = Lead.includes(:lead_detail, :lead_vehicles, :lead_drivers, :lead_violations).find_by(id: lead_id)
        if lead
         lead_drivers = lead.lead_drivers
      
         if lead_drivers.present?
          drivers_array = lead_drivers.map do |driver|
            {
              'marital_status' => LeadDriver.transform_marital_status_for_api(driver.marital_status)
            }
          end

          custom_hash = {
            zip: lead.zip,
           # drivers: drivers_array

          }
    
          # Convert the custom hash to JSON
          final_json = custom_hash.to_json
    
          # Display the final JSON representation
          puts final_json
        else
          puts 'LeadDrivers not found for the Lead in the database.'
        end
      else
        puts 'Lead not found in the database.'
      end
    end
    
    


end

