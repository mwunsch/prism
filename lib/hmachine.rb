require 'nokogiri'

require 'hmachine/pattern'
require 'hmachine/microformat'

module HMachine
  VERSION = "0.0.1"
  
  # def self.find(document)
  #   html = get_document(document)
  #   Microformat.find_all html
  # end
  # 
  # def self.find_with_url(url)
  #   # open url and call find method on resulting document
  # end
  # 
  # def self.get_document(html)
  #   html.is_a?(Nokogiri::XML::Node) ? html : Nokogiri::HTML.parse(html)
  # end
  
  def self.normalize(name)
    name.to_s.strip.downcase.intern
  end
  
  
  # Get/Set a function that defines how to find an element in a node.
  # The Search function should return a Nokogiri::XML::NodeSet.
  # eg. <tt>search {|node| node.css(element) }  
  def search(&block)
    @search = block if block_given?
    @search || lambda {|node| node }
  end
  
  # Search for the element in a node 
  def find_in(document)
    search.call(document)
  end
  
  # Is the element found in node?
  def found_in?(node)
    !find_in(node).empty?
  end
  
  # Define the patterns used to extract contents from node
  # Can be symbols that match to a Pattern module, or a lambda,
  # or pass it a block
  def extract_with(*patterns, &block)
    @parsers = []
    return @parsers << block if block_given?
    patterns.each do |pattern|
      @parsers << (pattern.respond_to?(:call) ? pattern : Pattern.map(pattern).parser )
    end
  end
  
  # Parsers that should be used to get content from a node
  def parsers
    @parsers
  end
  
  # Try each defined extraction pattern to get the content for the element
  # If none of them work, or if no parsers are defined,
  # just get the contents from the node.
  def extract_from(node)
    return node.content unless parsers
    content = nil
    parsers.each do |parser|
      content = parser.call(node)
      break if content
    end
    content || node.content
  end
  
  # Parse the node, finding the desired element, and extract the content for it
  def parse(document)
    if found_in?(document)
      contents = find_in(document).collect {|element| extract_from(element) }
      (contents.length == 1) ? contents.first : contents
    end
  end
  
  
end