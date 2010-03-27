module NBS
  class Artist
  
    attr_accessor :artist_id, :name, :xml, :options
      
    def initialize(artist_id, name="",options={})
      self.artist_id=artist_id
      self.name = name
      self.options = {"artistID"=>self.artist_id,"apiKey"=>$nbs_api_key,"format"=>"xml"}.merge(options)
    end
    
    def fetch_profile
      self.xml=Net::HTTP.get(URI.parse("#{NBS::NBS_CONFIG["base_url"]}getProfilesForArtist?#{self.options.to_url_params}")).to_s
    end
    
    # return a hash of urls keyed by the service.
    def profiles
      ####
      profs = {}
      self.to_hash["Profiles"][0]["Profile"].each do |item|
        profs[item["service"]]=item["url"]
      end
      return profs
    end
    
    def to_xml
      self.xml ||= fetch_profile
    end
    def to_hash
      Hash.from_xml(self.to_xml)
    end
    
    def method_missing(method_name,*args)
      if splits = method_name.to_s.split("_")
        puts args.inspect
        sdate = Date.parse(args[0].to_s)
        edate = Date.parse(args[1].to_s)
        opts = options.merge({"service"=>splits[0],"metric"=>splits[1],"start"=>sdate.to_s,"end"=>edate.to_s})
        puts opts.inspect
        puts "http://api.nextbigsound.com/v1_1/getDataForArtist?#{opts.to_url_params}"
        return Net::HTTP.get(URI.parse("#{NBS::NBS_CONFIG["base_url"]}getDataForArtist?#{opts.to_url_params}")).to_s
      else
        raise "Sorry that method does not exist. The proper format for finding data is service_metric(start,end)"
      end
    end
    
  end
end