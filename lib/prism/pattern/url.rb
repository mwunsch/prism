module Prism
  module Pattern
    module URL
      extend Prism
            
      validate {|node| node.matches?("a[href] ,area[href], img[src], object[data]") }
      
      extract do |url|
        if valid?(url)
          value = case url.node_name
            when 'a','area'
              url['href']
            when 'img'
              url['src']
            when 'object'
              url['data']
          end
          normalize(value) if value
        end
      end
      
      def self.normalize(url)
        uri = URI.parse(url).normalize
        return uri.to if uri.is_a?(URI::MailTo)
        uri.to_s
      end
      
    end
  end
end