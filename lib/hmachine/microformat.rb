module HMachine
  module Microformat

    def self.map(name)
      map = microformats[HMachine.normalize(name)]
      raise "#{name} is not a recognized microformat." unless map
      map
    end

    def self.microformats
      { :hcard      => HMachine::Microformat::HCard,
        :geo        => HMachine::Microformat::Geo,
        :adr        => HMachine::Microformat::Adr,
        :rellicense => HMachine::Microformat::RelLicense,
        :reltag     => HMachine::Microformat::RelTag,
        :votelinks  => HMachine::Microformat::VoteLinks,
        :xfn        => HMachine::Microformat::XFN,
        :xmdp       => HMachine::Microformat::XMDP,
        :xoxo       => HMachine::Microformat::XOXO }
    end

    def self.find(html, uformat = nil)
      if uformat
        map(uformat).parse HMachine.get(html)
      else
        find_all(html)
      end
    end
    
    def self.find_all(html)
      doc = HMachine.get(html)
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