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
        uri = URI.parse(url).normalize.to_s
        if uri.index('mailto:').eql?(0)
          uri.split('mailto:').last
        else
          uri
        end
      end
      
    end
  end
end