require File.join(File.dirname(__FILE__), 'test_helper')

class HMachineTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
  end
  
  test 'gets a Nokogiri doc for a string of HTML' do
    doc = HMachine.get_document(@html)
    assert doc.is_a?(Nokogiri::HTML::Document), "Document is a #{doc.class}"
  end
  
  test 'finds the microformats in a document' do
    microformats = HMachine.find(@html)
    assert microformats.respond_to? :length
  end
end