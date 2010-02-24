module Prism
  module Microformat
    class XFN < POSH::Anchor
      FRIENDLY_NAME = "XFN"
      WIKI_URL = 'http://microformats.org/wiki/XFN'
      XMDP = 'http://gmpg.org/xfn/11'
      
      @@friendship    = %w( contact acquaintance friend)
      @@physical      = %w( met )
      @@professional  = %w( co-worker colleague )
      @@geographical  = %w( co-resident neighbor )
      @@family        = %w( child parent sibling spouse kin )
      @@romantic      = %w( muse crush date sweetheart )
      @@identity      = %w( me )
      
      @@relationships = @@friendship + @@physical + @@professional + @@geographical + @@family + @@romantic + @@identity
      
      search do |doc|
        doc.css @@relationships.collect {|rel| "a[rel~='#{rel}']" }.join(', ')
      end
      
      validate do |a|
        return false unless a['rel']
        !@@relationships.reject { |rel| a['rel'].split.include?(rel) }.empty?
      end
      
      # Performant way to parse identity relationships
      def self.parse_me(document)
        nodes = document.css("a[rel~='me']")
        if !nodes.empty?
          contents = nodes.collect do |node|
            extract_from(node)
          end
          (contents.length == 1) ? contents.first : contents
        end
      end
      
      %w(friendship physical professional geographical family romantic identity).each do |type|
        class_eval %Q{
          def #{type}?
            !(@@#{type} & rel).empty?
          end
        }
      end
      alias me? identity?
      alias met? physical?
      
      def inspect
        "<#{self.class}:#{hash}: '#{rel.join(', ')}'>"
      end
      
    end
  end
end