require 'byebug'
require 'net/http'
require 'uri'

class Scraper
  attr_reader :content, :companies

  def initialize(page)
    uri = URI.parse("https://summerofcode.withgoogle.com/api/program/current/organization/?page=#{page}&page_size=48")
    request = Net::HTTP::Get.new(uri)
    request["Sec-Ch-Ua"] = "^\\^Google"
    request["Accept"] = "application/json, text/plain, */*"
    request["Referer"] = "https://summerofcode.withgoogle.com/organizations/"
    request["X-Content-Type-Options"] = "nosniff"
    request["Sec-Ch-Ua-Mobile"] = "?0"
    request["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    @content = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def into_array
    data_s = @content.body.partition("\"results\":[").last
    @companies = data_s.split("{\"")
    @companies.shift
  end
end

class Classifier
  attr_reader :raw_data
  attr_accessor :selected_data, :company_categories

  def initialize(company)
    @raw_data = company
    @company_categories = %w[id name website_url category contact_email mailing_list irc_channel tag_line precis
                             description tags primary_open_source_license image_url image_bg_color gplus_url twitter_url blog_url application_instructions topic_tags technology_tags proposal_tags ideas_list contact_method program_year]
  end
end
# rubocop: enable Layout/LineLength
