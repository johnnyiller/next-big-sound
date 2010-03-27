module NBS
  
  require 'net/http'
  require 'uri'
  
  class Search
  
    attr_accessor :options, :query, :api_key,:base_url, :xml
      
    def initialize(query, options={})
      self.options = {"query"=>query,"apiKey"=>$nbs_api_key,"format"=>"xml"}.merge(options)
      self.query = query
      self.api_key = api_key
      self.base_url = base_url
    end
    def fetch
      self.xml=Net::HTTP.get(URI.parse("#{NBS::NBS_CONFIG["base_url"]}search?#{self.options.to_url_params}")).to_s
    end
    def artists
      hash = Hash.from_xml(self.to_xml)
      a = []
      hash["Results"][0]["Result"].each do |item|
       a << Artist.new(item["NBSArtistID"][0],item["NBSArtistName"][0])
      end
      return a
    end
    def to_xml
      self.xml ||=fetch
    end
  end
end