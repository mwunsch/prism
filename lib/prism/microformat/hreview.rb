module Prism
  module Microformat
    class HReview < POSH
      FRIENDLY_NAME = "hReview"
      WIKI_URL = "http://microformats.org/wiki/hreview"
      XMDP = 'http://microformats.org/profile/hreview'
      
      name :hreview

      has_one :version, :summary, :type, :dtreviewed, :rating, :description
      has_one :item do
        extract :hcard
      end

      has_one :reviewer do
        extract :hcard
      end

    end
    register(:hreview, HReview)
  end
end
