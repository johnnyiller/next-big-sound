module NBS
  
  NBS_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/../config.yml")

  class Base
    
    extend NBS::MemcachedMemoize
    
    def initialize(api_key)
      $nbs_api_key = api_key
      #puts CACHE_ENABLED
    end
    # return a search object that you can manipulate
    # if you prefer to just use the xml simply type to_xml
    # this method with actually fetch the result
    def search(query, options={} )
      search = NBS::Search.new(query,options)
      search.fetch
      return search
    end
    def self.t_to_d(string_timestamp)
      return Date.parse(Time.at(string_timestamp.to_i).to_s)
    end
    remember :search
  end
end