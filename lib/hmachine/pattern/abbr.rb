module HMachine
  module Pattern
    module Abbr
      extend HMachine
      WIKI_URL = 'http://microformats.org/wiki/abbr-design-pattern'
  
      search {|element| element.css('abbr') }
  
      validate {|abbr| abbr.node_name.eql?('abbr') }
  
      extract do |node|
        if (node.node_name.eql?('abbr') && node['title'])
          node['title']
        else
          node.content.strip
        end
      end
            
    end
  end
end