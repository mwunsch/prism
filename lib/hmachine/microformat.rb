require 'hmachine/microformat/base'
require 'hmachine/microformat/hcard'

module HMachine
  module Microformat
    
    def self.find_hcard(html)
      doc = HMachine.get_document(html)
      find_in_node(HCard, doc)
    end
    
    def self.find_all(html)
      find_hcard html
    end
    
    def self.find_in_node(microformat, node)
      hformat = normalize(microformat)
      microformats = []
      hformat.find_in(node) do |element|
        microformats << create_for_node(hformat, element) if hformat.validate(element)
      end
      microformats
    end
    
    def self.create_for_node(microformat, node)
      hformat = normalize(microformat)
      return unless hformat.validate(node)
      hformat.new node
    end
    
    def self.normalize(name)
      return name if name.respond_to?(:superclass)
      case name.to_s.strip.downcase.intern
        when :hcard
          HCard
        else
          raise "#{name} is not a recognized microformat."
      end
    end
    
  end
end