module NBS
  class Artist
    extend NBS::MemcachedMemoize
    attr_accessor :artist_id, :name, :xml, :options, :post_params
      
    PROFILES = %w(all myspace lastfm ilike facebook twitter youtube reverbnation ourstage soundcloud purevolume bebo virb amiestreet jamlegend vimeo)
      
    def initialize(artist_id, name="",options={})
      self.artist_id=artist_id
      self.name = name
      self.options = {"artistID"=>self.artist_id,"format"=>"xml"}.merge(options)
      self.post_params={}
      puts options.inspect
      if options.has_key?("start_date") && options.has_key?("end_date")
        self.post_params["data[start]"] = Time.parse(options["start_date"])
        self.post_params["date[end]"] = Time.parse(options["end_date"])
      end
    end
    
    def fetch_profiles(artist,sdate,edate)
      if self.post_params.empty?
        puts "not doing expected action"
        puts self.post_params
        self.xml=Net::HTTP.get(URI.parse("#{$nbs_api_key}metrics/artist/#{self.artist_id}.xml")).to_s
      else
        puts "doing expected action"
        resp =  Net::HTTP.post_form(URI.parse("#{$nbs_api_key}metrics/artist/#{self.artist_id}.xml"),self.post_params)
        #puts resp.body
        self.xml = resp.body
      end
    end
    
    # return a hash of urls keyed by the service.
    def profiles
      ####
      #puts self.to_xml
      #puts self.to_xml
      @profs ||= long_function
      return @profs
    end
    def long_function
      profs={}
      begin
        startd = NBS::Base.t_to_d(self.to_hash["data"][0]["criteria"][0]["start"][0]["content"])
        endd = NBS::Base.t_to_d(self.to_hash["data"][0]["criteria"][0]["end"][0]["content"])
        #puts startd.inspect
        #puts endd.inspect
        #puts startd.inspect
        #endd = 
        self.to_hash["data"][0]["profiles"][0]["profile"].each do |item|
          profile = NBS::ArtistProfile.new(self.artist_id, item["service"] ,item["url"]) 
          metric_hash = {}
          if defined?(item["metrics"][0]["metric"]) && item["metrics"][0]["metric"]!=nil && !item["metrics"][0]["metric"].empty?
           item["metrics"][0]["metric"].each do |mdata|
            #puts mdata["name"]
            metric = NBS::Metric.new(self.artist_id,item["service"],mdata["name"],startd,endd)
             dps = []
             if defined?(mdata["value"]) && mdata["value"]!=nil
              mdata["value"].each do |dp|
                #puts "got here"
               dps << NBS::DataPoint.new(NBS::Base.t_to_d(dp["timestamp"]),dp["content"])
              end
             end
             metric.load_datapoints(dps)
             metric_hash[mdata["name"]]=metric
           end
          end 
          profile.set_metrics(metric_hash)
          profs[item["service"][0]["content"].to_s]=profile
        end
      rescue
      end
      return profs
    end
    def to_xml
      self.xml ||= fetch_profiles(self.artist_id,self.options["start_date"], self.options["end_date"])
    end
    def to_hash
      Hash.from_xml(self.to_xml)
    end
    def youtube_videos
      @youtube_fetch ||= Net::HTTP.get(URI.parse("#{$nbs_api_key}youtube/artist/#{self.artist_id}.xml")).to_s
      h = Hash.from_xml(@youtube_fetch)
    
      arr =[]
      begin 
        h["data"][0]["youtubes"][0]["youtube"].each do |g|
          arr << g["url"].to_s
       end
      rescue 
      end
      return arr
    end
    def genres
      @genre_fetch ||= Net::HTTP.get(URI.parse("#{$nbs_api_key}genres/artist/#{self.artist_id}.xml")).to_s
      h = Hash.from_xml(@genre_fetch)
      arr =[]
      begin
      h["data"][0]["genres"][0]["genre"].each do |g|
        arr << g["name"].to_s
      end
      rescue
      end
      return arr
    end
    remember :fetch_profiles
  end
end