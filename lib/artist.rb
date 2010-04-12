module NBS
  class Artist
    
    attr_accessor :artist_id, :name, :xml, :options
      
    PROFILES = %w(all myspace lastfm ilike facebook twitter youtube reverbnation ourstage soundcloud purevolume bebo virb amiestreet jamlegend vimeo)
      
    def initialize(artist_id, name="",options={})
      self.artist_id=artist_id
      self.name = name
      self.options = {"artistID"=>self.artist_id,"apiKey"=>$nbs_api_key,"format"=>"xml"}.merge(options)
    end
    
    def fetch_profiles
      self.xml=Net::HTTP.get(URI.parse("#{NBS::NBS_CONFIG["base_url"]}getProfilesForArtist?#{self.options.to_url_params}")).to_s
    end
    
    # return a hash of urls keyed by the service.
    def profiles
      ####
      puts self.to_xml
      profs = {}
      begin
        self.to_hash["Profiles"][0]["Profile"].each do |item|
          profs[item["service"].to_s]=ArtistProfile.new(self.artist_id, item["service"] ,item["url"])
        end
      rescue
      end
      return profs
    end
    def to_xml
      self.xml ||= fetch_profiles
    end
    def to_hash
      Hash.from_xml(self.to_xml)
    end
    
    def method_missing(method_name,*args)
      splits = method_name.to_s.split("_")
      prof = self.profiles[splits[0].upcase]
      metrics = prof.metrics(args[0],args[1])
      return metrics[splits[1].downcase.to_s].data_points
    end

  end
end