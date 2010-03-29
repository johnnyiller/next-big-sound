module NBS
  
  $LOAD_PATH << './lib'
  require 'yaml'
  require 'hash_extension'
  require 'search'
  require 'artist'
  require 'artist_profile'
  require 'metric'
  require 'datapoint'
  

  NBS_CONFIG = YAML.load_file("config.yml")
  
  class Base
     
    def initialize(api_key)
      $nbs_api_key = api_key
    end
    # return a search object that you can manipulate
    # if you prefer to just use the xml simply type to_xml
    # this method with actually fetch the result
    def search(query, options={} )
      search = Search.new(query,options)
      search.fetch
      return search
    end
  end
end