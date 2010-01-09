require File.join(File.dirname(__FILE__), 'test_helper')

class MicroformatTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @document = Nokogiri::HTML.parse(@html)
    @hcard_class = HMachine::Microformat::HCard
  end
    
  test 'creates a microformat for a given node' do
    hcard = HMachine::Microformat.create_for_node(@hcard_class, @document.css(@hcard_class::ROOT_SELECTOR)[0])
    assert hcard.is_a?(@hcard_class), "Created a #{hcard.class}"
  end
  
  test "rejects invalid nodes" do
    hcard = HMachine::Microformat.create_for_node(@hcard_class, @document)
    assert hcard.nil? 
  end
  
  test 'finds a given microformat in a document' do
    first_hcard = HMachine::Microformat.find_in_node(@hcard_class, @document)[0]
    assert first_hcard.is_a?(@hcard_class), "Object is a #{first_hcard.class}"
  end
  
  test 'knows that there are multiple microformats in a document' do
    hcards = HMachine::Microformat.find_in_node(@hcard_class, @document)
    assert hcards.respond_to? :length
  end
  
  test 'finds all the microformats in a document' do
    microformats = HMachine::Microformat.find_all(@document)
    assert microformats.length == 1, "Number of Microformats in document: #{microformats.length}"
  end
  
  describe 'Find hCard' do    
    test 'document contains an hCard' do
      first_hcard = HMachine::Microformat.find_hcard(@document)[0]
      assert first_hcard.is_a?(@hcard_class), "Object is a #{first_hcard.class}"
    end
  end
  
end