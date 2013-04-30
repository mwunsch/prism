require File.join(File.dirname(File.absolute_path(__FILE__)),'..','test_helper')

class HAtomTest < Test::Unit::TestCase
  @@klass = Prism::Microformat::HAtom

  describe 'first example test' do
    def self.before_all
      @doc ||= test_fixture('hatom/example1.html')
      @hatom ||= @@klass.parse(@doc)
    end

    setup do
      @hatom ||= self.class.before_all
    end

    test 'The title is a singular value' do
      hentry = @hatom.hentry
      assert_equal "Wiki Attack", hentry[0].entry_title
    end

    test 'The content contains html' do
      hentry = @hatom.hentry
      content = <<-EOS
     <p>We had a bit of trouble with ...</p>
     <p>We've restored the wiki and ...</p>
     <p>If anyone is working to combat said spammers ...</p>
      EOS
      assert_equal content.strip, hentry[0].entry_content
    end

    test 'The published is a time' do
      hentry = @hatom.hentry
      assert_equal Time.parse('2005-10-10 14:07:00 -0700'), hentry[0].published
    end

    test 'The author is an hcard' do
      hentry = @hatom.hentry
      hcard = hentry[0].author
      assert_equal Prism::Microformat::HCard, hcard.class
      assert_equal 'Ryan King', hcard.fn
      assert_equal 'King', hcard.n[:family_name]
      assert_equal 'Ryan', hcard.n[:given_name]
      assert_equal 'http://theryanking.com/', hcard.url[0]
    end

    test 'The tags are a list of values' do
      hentry = @hatom.hentry
      assert_equal ['mediawiki', 'microformats', 'spam'], hentry[0].tags
    end

  end

  describe 'second example test' do
    def self.before_all
      @doc ||= test_fixture('hatom/example2.html')
      @hatom ||= @@klass.parse(@doc)
    end

    setup do
      @hatom ||= self.class.before_all
    end

    test 'The title is a singular value' do
      hentry = @hatom.hentry
      assert_equal "Nelson's final prayer", hentry[0].entry_title
    end

    test 'The content is an html value' do
      hentry = @hatom.hentry
      assert_equal "Nelson's final prayer", hentry[0].entry_content
    end

    test 'The bookmark is a rel-bookmark' do
      hentry = @hatom.hentry
      assert_equal "2005_10_16_nataliesolent_archive.html#112993192128302715", hentry[0].bookmark
    end

  end

end

