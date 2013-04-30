module Prism
  module Microformat

    def self.map(name)
      map = microformats[Prism.normalize(name)]
      map = format_to_class(map) if map
      raise "#{name} is not a recognized microformat." unless map
      map
    end

    def self.microformats
      { :hatom      => "HAtom",
        :hcard      => "HCard",
        :hcalendar  => "HCalendar",
        :geo        => "Geo",
        :adr        => "Adr",
        :rellicense => "RelLicense",
        :reltag     => "RelTag",
        :votelinks  => "VoteLinks",
        :xfn        => "XFN",
        :xmdp       => "XMDP",
        :xoxo       => "XOXO" }
    end

    def self.format_to_class(format)
      Prism::Microformat.const_get(format)
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
        klass = format_to_class(uf)
        klass.parse(doc)
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
require 'prism/microformat/hcalendar'
require 'prism/microformat/hcard'
require 'prism/microformat/hatom'
