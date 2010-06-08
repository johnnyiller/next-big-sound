module NBS
  
  class Metric
    extend NBS::MemcachedMemoize
    
    attr_accessor :artist_id,:service_type,:metric,:sdate,:edate, :xml
    
   
    def initialize(artist_id,service_type,metric,sdate,edate)
      self.artist_id = artist_id
      self.service_type = service_type
      self.metric = metric
      self.sdate = Date.parse(sdate.to_s)
      self.edate = Date.parse(edate.to_s)  
    end
    def fetch(myopts_test={})
      options = {"service"=>self.service_type,"metric"=>self.metric,"start"=>self.sdate.to_s,"end"=>self.edate.to_s,"artistID"=>self.artist_id,"apiKey"=>$nbs_api_key,"format"=>"xml"}
      puts "#{NBS::NBS_CONFIG["base_url"]}getDataForArtist?#{options.to_url_params}"
      statsxml = Net::HTTP.get(URI.parse("#{NBS::NBS_CONFIG["base_url"]}getDataForArtist?#{options.to_url_params}")).to_s
    end
    def data_points
      unless @data_points.empty?
        return @data_points
      end
      begin
        points = to_hash["Profiles"][0]["Profile"][0]["DataPoint"]
        dps = []
        points.each do |dp|
          dps << NBS::DataPoint.new(dp["date"],dp["value"])
        end
        return dps
      rescue
        return []
      end
    end
    # this will allow me to load the data that I previously fetched.
    def load_datapoints(data_points)
      @data_points = data_points
    end
    # delivers the datapoints as a Date keyed hash.
    #def date_points_hash
    #end
    #def xml_data_points
      #to_hash["Profiles"][0]["Profile"][0]["DataPoint"].to_xml
    #end
    def to_xml
      self.xml ||= fetch({"service"=>self.service_type,"metric"=>self.metric,"start"=>self.sdate.to_s,"end"=>self.edate.to_s,"artistID"=>self.artist_id,"apiKey"=>$nbs_api_key,"format"=>"xml"})
    end
    def to_hash
      Hash.from_xml(to_xml)
    end
    remember :fetch 
  end
end