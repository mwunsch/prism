module Prism
  module Microformat

    def self.map(name)
      map = microformats[Prism.normalize(name)]
      raise "#{name} is not a recognized microformat." unless map
      map
    end

    def self.microformats
      { :hcard      => Prism::Microformat::HCard,
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

require 'hmachine/microformat/reltag'
require 'hmachine/microformat/rellicense'
require 'hmachine/microformat/votelinks'
require 'hmachine/microformat/xoxo'
require 'hmachine/microformat/xmdp'
require 'hmachine/microformat/xfn'
require 'hmachine/microformat/geo'
require 'hmachine/microformat/adr'
require 'hmachine/microformat/hcard'