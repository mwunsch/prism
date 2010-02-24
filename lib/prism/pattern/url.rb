module Prism
  module Pattern
    module URL
      extend Prism
            
      validate {|node| node.matches?("a[href] ,area[href], img[src], object[data]") }
      
      extract do |url|
        if valid?(url)
          value = if (url.node_name.eql?('a') || url.node_name.eql?('area'))
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
          email = uri.split('mailto:')[1].split('?').first
        else
          uri
        end
      end
      
    end
  end
end