require 'net/http'
require 'uri'
require 'json'

module InsuranceExchangeIntegration

   

    def InsuranceExchangeIntegration.call_transfer()

        api_token = "API" 
        placement_id = "ID"
        data = { "zip" => "90210"}
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


end

