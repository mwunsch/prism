module Prism
  module Microformat

    def self.map(name)
      map = microformats[Prism.normalize(name)]
      raise "#{name} is not a recognized microformat." unless map
      map
    end

    def self.microformats
      { :hcard      => Prism::Microformat::HCard,
        :hcalendar  => Prism::Microformat::HCalendar,
        :geo        => Prism::Microformat::Geo,
        :adr        => Prism::Microformat::Adr,
        :rellicense => Prism::Microformat::RelLicense,
        :reltag     => Prism::Microformat::RelTag,
        :votelinks  => Prism::Microformat::VoteLinks,
        :xfn        => Prism::Microformat::XFN,
        :xmdp       => Prism::Microformat::XMDP,
        :xoxo       => Prism::Microformat::XOXO }
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
require 'prism/microformat/hcalendar'
require 'prism/microformat/hcard'
