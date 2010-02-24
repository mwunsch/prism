module Prism
  module Pattern
    module Abbr
      extend Prism
      WIKI_URL = 'http://microformats.org/wiki/abbr-design-pattern'
  
      search {|element| element.css('abbr[title]') }
  
      validate {|abbr| abbr.node_name.eql?('abbr') && abbr['title'] }
  
      extract do |node|
        if valid?(node)
          DateTime.valid?(node['title']) ? DateTime.extract_from(node['title']) : node['title']
        else
          node.content.strip
        end
      end
            
    end
  end
end