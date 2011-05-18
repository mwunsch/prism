require File.join(File.dirname(File.absolute_path(__FILE__)),'..','test_helper')

class HReviewTest < Test::Unit::TestCase
  @@klass = Prism::Microformat::HReview
  
  # Adapted from:
  # http://microformats.org/wiki/hreview#Restaurant_reviews
  # FIX: Descriptions
  describe 'single occurence test' do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hreview/hreview1.html'))
      @hreview ||= @@klass.parse_first(@doc)
    end
    
    setup do
      @hreview ||= self.class.before_all
    end
    
    test 'The rating is a singular value' do
      assert_respond_to @hreview, :rating
      assert @hreview.has_property?(:rating)
      assert_equal '5', @hreview.rating
    end

    test 'The summary is a singular value' do
      assert_respond_to @hreview, :summary
      assert @hreview.has_property?(:summary)
      assert_equal 'Crepes on Cole is awesome', @hreview.summary
    end

    test 'The reviewer is a singular value' do
      assert_respond_to @hreview, :reviewer
      assert @hreview.has_property?(:reviewer)
      assert_equal 'Tantek', @hreview.reviewer[:fn]
    end

    test 'The description is a singular value' do
      assert_respond_to @hreview, :description
      assert @hreview.has_property?(:description)
      assert_equal "Crepes on Cole is one of the best little \n"+
        "  creperies in San Francisco.\n"+
        "  Excellent food and service. Plenty of tables in a variety of sizes \n"+
        "  for parties large and small.", @hreview.description
    end

    describe 'Check item nested in description' do

      setup do
        @item = @hreview.item
      end

      test 'The item is a singular value' do
        assert_respond_to @hreview, :item
        assert @hreview.has_property?(:item)
      end

      test 'item[:fn] is a singular value' do
        assert_equal 'Crepes on Cole', @item[:fn]
      end

      test 'item[:adr] is a singular value' do
        assert_equal ['San Francisco'], @item.adr.first[:locality]
        # TODO: Decide if this is the correct outcome
      end

    end
  end
end
