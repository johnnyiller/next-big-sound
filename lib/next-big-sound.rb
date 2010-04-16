

require 'rubygems'
require "cgi"
require 'xmlsimple'
require 'rubygems'
require 'memoize'
require 'yaml'

class Hash
  def to_url_params
    elements = []
    keys.size.times do |i|
      elements << "#{CGI::escape(keys[i])}=#{CGI::escape(values[i])}"
    end
    elements.join('&')
  end
  
  def self.from_xml(xml_data)
    XmlSimple.xml_in(xml_data)
  end 
end




require 'search'
require 'artist'
require 'artist_profile'
require 'metric'
require 'datapoint'