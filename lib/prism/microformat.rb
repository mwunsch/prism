module Prism
  module Microformat

    # Register a microformat
    # +microformat+ is the symbol for this microformat and +klass+ is the
    # class that describes it.
    def self.register(microformat, klass)
      @microformats ||= {}
      @microformats[microformat] = klass
    end

    def self.microformats
      @microformats || {}
    end

    def self.map(name)
      map = microformats[Prism.normalize(name)]
      raise "#{name} is not a recognized microformat." unless map
      map
    end

    def self.find(html, uformat = nil)
      if uformat
        map(uformat).parse Prism.get(html)
      else
        find_all(html)
      end
    end
    
    def self.find_all(html)
      doc = Prism.get(html)
      uformats = microformats.values.collect do |uf|
        uf.parse(doc)
      end
      uformats.compact.flatten
    end
    
  end
end

require 'prism/microformat/reltag'
require 'prism/microformat/rellicense'
require 'prism/microformat/votelinks'
require 'prism/microformat/xoxo'
require 'prism/microformat/xmdp'
require 'prism/microformat/xfn'
require 'prism/microformat/geo'
require 'prism/microformat/adr'
require 'prism/microformat/hcard'
require 'prism/microformat/hcalendar'
require 'prism/microformat/hreview'
