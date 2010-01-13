require 'uri'
require 'nokogiri'

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
  
  # Get/Set a function that tests to make sure a given node is
  # the element we want. Should return truthy.
  # Default just tests to see if the node passed is a child of its parent node.
  def validate(&block)
    @validate = block if block_given?
    @validate || lambda { |node| find_in(node.parent).children.include?(node) }
  end
  
  # Is this a valid node?
  def valid?(node)
    validate.call(node)
  end
  
  # Define the patterns used to extract contents from node
  # Can be symbols that match to a Pattern module, or a lambda,
  # or pass it a block
  def extract(*patterns, &block)
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
      element_hash = {}
      contents = find_in(document).collect do |element|
        values = extract_from(element)
        element_hash.merge!(values) if values.respond_to?(:keys)
        values
      end
      return element_hash unless element_hash.empty?
      (contents.length == 1) ? contents.first : contents
    end
  end
  
  # Parse the node, extracting the content for the first instance of the element
  def parse_first(document)
    if found_in?(document)
      extract_from(find_in(document).first)
    end
  end 
  
end

require 'hmachine/pattern'
require 'hmachine/microformat'