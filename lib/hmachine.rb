require 'uri'
require 'nokogiri'

require 'hmachine/microformat'

module HMachine
  VERSION = "0.0.1"
  
  def self.find(document)
    html = get_document(document)
    Microformat.find_all html
  end
  
  def self.find_with_url(url)
    # open url and call find method on resulting document
  end
  
  def self.get_document(html)
    html.is_a?(Nokogiri::XML::Node) ? html : Nokogiri::HTML.parse(html)
  end
end