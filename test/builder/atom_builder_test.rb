require File.join(File.dirname(File.absolute_path(__FILE__)),'..','test_helper')

class AtomBuilderTest < Test::Unit::TestCase
  @@klass = Prism::Builder::AtomBuilder

  setup do
    @atom = @@klass.new
    @doc = test_fixture('hatom/example1.html')
    @hatom = Prism::Microformat::HAtom.parse(@doc)
  end

  def parse_atom
    @atom.build
    @xml_doc = Nokogiri::XML(@atom.to_s){ |config| config.strict }
  end

  should "create an empty atom feed" do
    parse_atom
    assert_not_equal "", @xml_doc.xpath('/xmlns:feed').to_s
  end

  should "create a feed" do
    @atom.add_hatom(@hatom)
    parse_atom
    assert_equal "Wiki Attack", @xml_doc.xpath('/xmlns:feed/xmlns:entry[1]/xmlns:title').text
    assert_equal "2005-10-10T21:07:00+00:00", @xml_doc.xpath('/xmlns:feed/xmlns:entry[1]/xmlns:published').text
    assert_equal "We had a bit of trouble with ...", @xml_doc.xpath('/xmlns:feed/xmlns:entry[1]/xmlns:summary').text
    assert_equal "Ryan King", @xml_doc.xpath('/xmlns:feed/xmlns:entry[1]/xmlns:author/xmlns:name').text
    assert_equal "http://theryanking.com/", @xml_doc.xpath('/xmlns:feed/xmlns:entry[1]/xmlns:author/xmlns:uri').text
  end

end

