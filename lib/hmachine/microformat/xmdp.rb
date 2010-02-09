module HMachine
  module Microformat
    class XMDP < POSH::DefinitionList
      WIKI_URL = 'http://microformats.org/wiki/XMDP'
      XMDP = 'http://gmpg.org/xmdp/1'
      
      search {|doc| doc.css('dl.profile') }
      
      validate {|dl| dl.matches?('dl.profile') }
      
    end
  end
end