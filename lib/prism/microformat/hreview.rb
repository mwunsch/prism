module Prism
  module Microformat
    class HReview < POSH
      FRIENDLY_NAME = "hReview"
      WIKI_URL = "http://microformats.org/wiki/hreview"
      XMDP = 'http://microformats.org/profile/hreview'

      name :hreview

      # Extracts a property from a node using a given pattern
      def self.extract_property(node, property, microformat=:valueclass)
        prop_node = node.css(".#{property.to_s}")
        return nil unless prop_node.length >= 1
        parser = Prism.map(microformat)
        parser.extract_from(prop_node.first)
      end

      has_one :version, :summary, :dtreviewed, :rating, :description

      # FIX: Should try to infer type if type missing
      # FIX: Should return as a symbol
      has_one :type

      has_one :item do
        extract do |node|
          value = find_one_of(node, :hcard, :hcalendar)

          unless value
            fn = HReview.extract_property(node, :fn)
            url = HReview.extract_property(node, :url, :url)
            photo = HReview.extract_property(node, :photo, :url)
            # FIX: Using a Struct breaks away from using Prism::POSH::Base
            # but I was struggling to get it to work otherwise
            item = Struct.new(:fn, :url, :photo) do
              def to_h
                {fn: fn, url: url, photo: photo}
              end
            end
            value = item.new(fn, url, photo)
          end
          value
        end
      end

      has_one :reviewer do
        # FIX: If there is no reviewer, then the parser should look outside
        # of the hReview
        # NOTE: By creating an hCard from a plain text reviewer this diverges
        # from the hReview 0.3 standard, but is needed because it is so common
        # where people were using hReview 0.2
        extract do |node|
          value = find_one_of(node, :hcard)

          unless value
            # FIX: Using a Struct breaks away from using Prism::POSH::Base
            # but I was struggling to get it to work otherwise
            reviewer = Struct.new(:fn) do
              def to_h
                {fn: fn}
              end
            end
            value = reviewer.new(node.content.strip)
          end
          value
        end
      end

    end

  end
end
