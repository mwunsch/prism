require 'uri'

module HMachine
  module Pattern
    module URL
      extend HMachine
            
      validate {|node| node.matches?("a[href] ,area[href], img[src], object[data]") }
      
      extract do |url|
        if valid?(url)
          value = if (url.node_name.eql?('a') || url.node_name.eql?('a'))
            url['href']
          elsif url.node_name.eql?('img')
            url['src']
          elsif url.node_name.eql?('object')
            url['data']
          end
          normalize(value) if value
        end
      end
      
      def self.normalize(url)
        URI.parse(url).normalize.to_s
      end
      
    end
  end
end