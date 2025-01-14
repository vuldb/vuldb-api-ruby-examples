=begin
    vuldb_api_demo - Ruby VulDB API Demo

    License: GPL-3.0
    Required Dependencies: 
        * net/http
        * uri
        * json
    Optional Dependencies: None
=end

require 'net/http'
require 'uri'
require 'json'

class VulDBApiDemo
  def self.run
    begin
      # API-URL
      url = URI.parse("https://vuldb.com/?api")

      # Headers for authentication
      personal_api_key = "" # Enter your personal API key here.
      user_agent = "VulDB API Advanced Ruby Demo Agent"

      # Request body parameters
      recent = "5" # Default value is "5"
      details = "0" # Default value is "0"
      id = nil # Example: "290848", enter specific VulDB id to search for (Default value is nil)
      cve = nil # Example: "CVE-2024-1234", enter a CVE to search for (Default value is nil)

      # Construct the request body
      request_body =
        if id.nil? && cve.nil?
          "recent=#{recent}&details=#{details}"
        elsif !cve.nil?
          "search=#{cve}&details=#{details}"
        else
          "id=#{id}&details=#{details}"
        end

      # Initialize the HTTP request
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url.path)
      request["User-Agent"] = user_agent
      request["X-VulDB-ApiKey"] = personal_api_key
      request.body = request_body

      # Send the request
      response = http.request(request)

      if response.code.to_i == 200
        # Parse and display the response body
        puts "Response:"
        puts response.body
      else
        # Handle non-200 response codes
        puts "Request failed with response code: #{response.code}"
        puts "Response message: #{response.message}"
      end

    rescue URI::InvalidURIError => e
      puts "Invalid URI: #{e.message}"
    rescue Net::HTTPError => e
      puts "HTTP Error: #{e.message}"
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

# Run the demo
VulDBApiDemo.run
