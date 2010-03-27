require 'helper'
require 'yaml'

class TestNextBigSound < Test::Unit::TestCase
  include NBS
  context "Has Valid api key" do 
    setup do 
      # get the api key from the yaml file
      YAML.load_file("./test/credentials.yml").each { |key,value| instance_variable_set("@#{key}", value) }
      @nbs = Base.new(@api_key)
    end
  	context "Assuming we are able to search for the killers" do 
	    setup do 
         @searchobj = @nbs.search("The Killers")
      end
	    should "Be able to find The Killers ArtistID" do
        assert_match /<NBSArtistID>\d+<\/NBSArtistID>/i, @searchobj.to_xml
    	end
    	should "have an array of results" do 
  	    assert !@searchobj.artists.empty?
  	  end
  	  should "have first result with artist name of The Killers" do 
	      assert_equal "The Killers", @searchobj.artists.first.name
	    end
	    should "be able to get some data" do
	      assert @searchobj.artists.first.myspace_plays("4/24/2009","4/24/2010").is_a?(Array)
      end
	  end
    #should "have many re"
  end
end
