require "cgi"
require 'rubygems'
require 'xmlsimple'

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