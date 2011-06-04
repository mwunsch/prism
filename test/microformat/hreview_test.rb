require File.join(File.dirname(File.absolute_path(__FILE__)),'..','test_helper')

class HReviewTest < Test::Unit::TestCase
  @@klass = Prism::Microformat::HReview
  
  # hreview1.html
  describe 'single occurence test' do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hreview/hreview1.html'))
      @hreview ||= @@klass.parse_first(@doc)
    end
    
    setup do
      @hreview ||= self.class.before_all
    end
    
    test 'The version is a singular value' do
      assert_respond_to @hreview, :version
      assert @hreview.has_property?(:version)
      assert_equal '0.3', @hreview.version
    end

    test 'The summary is a singular value' do
      assert_respond_to @hreview, :summary
      assert @hreview.has_property?(:summary)
      assert_equal 'Crepes on Cole is awesome', @hreview.summary
    end

    test 'The rating is a singular value' do
      assert_respond_to @hreview, :rating
      assert @hreview.has_property?(:rating)
      assert_equal '5', @hreview.rating
    end

    test 'The type is a singular value' do
      assert_respond_to @hreview, :type
      assert @hreview.has_property?(:type)
      assert_equal "business", @hreview.type
    end

    test 'The item is a singular value' do
      assert_respond_to @hreview, :item
      assert @hreview.has_property?(:item)
    end

    test 'The reviewer is a singular value' do
      assert_respond_to @hreview, :reviewer
      assert @hreview.has_property?(:reviewer)
    end

    test 'The dtreviewed is a singular value' do
      assert_respond_to @hreview, :dtreviewed
      assert @hreview.has_property?(:dtreviewed)
      assert_equal 18, @hreview.dtreviewed.day
      assert_equal 04, @hreview.dtreviewed.mon
      assert_equal 2005, @hreview.dtreviewed.year
    end

    test 'The description is a singular value' do
      assert_respond_to @hreview, :description
      assert @hreview.has_property?(:description)
      assert_equal "Crepes on Cole is one of the best little creperies in "+
                   "San Francisco. Excellent food and service. Plenty of "+
                   "tables in a variety of sizes for parties large and small.",
                   @hreview.description.gsub(/\n|\r/, "").squeeze(' ')
    end
  end

  # hreview2.html
  describe 'extracting item hCard test' do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hreview/hreview2.html'))
      @hreview ||= @@klass.parse_first(@doc)
    end

    setup do
      @hreview ||= self.class.before_all
      @item = @hreview.item
    end

    test 'item.fn is a singular value' do
      assert_equal 'Crepes on Cole', @item.fn
    end

    test 'item.org[0].organization_name is a singular value' do
      assert_equal 'Crepes on Cole', @item.org[0].organization_name
    end

    test 'item.adr[0].locality is a singular value' do
      assert_equal ['San Francisco'], @item.adr[0].locality
    end
  end

  # hreview3.html
  describe 'extracting item fn (url|photo) test' do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hreview/hreview3.html'))
      @hreview ||= @@klass.parse_first(@doc)
    end

    setup do
      @hreview ||= self.class.before_all
      @item = @hreview.item
    end

    test 'item.fn is a singular value' do
      assert_equal 'Crepes on Cole', @item.fn
    end

    test 'item.url is a singular value' do
      assert_equal 'http://example.com/', @item.url
    end

    test 'item.photo is a singular value' do
      assert_equal 'http://example.com/photos/crepes.png', @item.photo
    end
  end

  # hreview4.html
  describe 'extracting reviewer hCard test' do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hreview/hreview4.html'))
      @hreview ||= @@klass.parse_first(@doc)
    end

    setup do
      @hreview ||= self.class.before_all
    end

    test 'reviewer.fn is a singular value' do
      assert_equal 'Tantek', @hreview.reviewer.fn
    end
  end

  # hreview5.html
  describe "extracting reviewer that isn't properly wrapped in an hCard test" do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hreview/hreview5.html'))
      @hreview ||= @@klass.parse_first(@doc)
    end

    setup do
      @hreview ||= self.class.before_all
    end

    test 'reviewer.fn is a singular value' do
      assert_equal 'Tantek', @hreview.reviewer.fn
    end
  end
end
