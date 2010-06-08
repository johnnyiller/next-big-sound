module NBS
  
  require 'net/http'
  require 'uri'
  
  class Search
        
    attr_accessor :options, :query, :api_key,:base_url, :xml
      
    def initialize(query, options={})
      self.options = {"q"=>query,"format"=>"xml"}.merge(options)
      self.query = query
      self.api_key = api_key
      self.base_url = base_url
    end
    def fetch
      puts "#{$nbs_api_key}artists/search?#{self.options.to_url_params}"
      self.xml=Net::HTTP.get(URI.parse("#{$nbs_api_key}artists/search.#{self.options["format"]}?#{self.options.to_url_params}")).to_s
      #puts self.xml
    end
    def artists(options={})
      hash = Hash.from_xml(self.to_xml)
      a = []
      #puts hash.inspect    
      begin
        hash["data"][0]["artists"][0]["artist"].each do |item|
          a << NBS::Artist.new(item["id"],item["name"][0],options)
        end
      rescue
      end
      return a
    end
    def to_xml
      self.xml ||=fetch
    end
  end
end