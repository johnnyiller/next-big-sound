require 'rubygems'
require "cgi"
require 'xmlsimple'
require 'rubygems'
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

directory = File.expand_path(File.dirname(__FILE__))
require File.join(directory,"next-big-sound", "memoize")
require File.join(directory,"next-big-sound", "base")
require File.join(directory,"next-big-sound", "search")
require File.join(directory,"next-big-sound","artist")
require File.join(directory,"next-big-sound","artist_profile")
require File.join(directory,"next-big-sound", "metric")
require File.join(directory,"next-big-sound","datapoint")

