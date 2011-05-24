module Prism
  module Microformat
    class HReview < POSH
      FRIENDLY_NAME = "hReview"
      WIKI_URL = "http://microformats.org/wiki/hreview"
      XMDP = 'http://microformats.org/profile/hreview'
      
      name :hreview

      has_one :version, :summary, :dtreviewed, :rating, :description

      # FIX: Should try to infer type if type missing
      # FIX: Should return as a symbol
      has_one :type

      has_one :item do
        # FIX: Also needs to recognize: fn (url || photo)
        extract :hcard, :hcalendar
      end

      has_one :reviewer do
        # FIX: If there is no reviewer, then the parser should look outside
        # of the hReview
        extract :hcard
      end

    end
    register(:hreview, HReview)
  end
end
