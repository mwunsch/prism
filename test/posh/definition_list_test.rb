require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PoshDefinitionListTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('xmdp.html')
    @doc = Nokogiri.parse(@html)
  end
  
  should 'pull itself out of a document' do
    dl = HMachine::POSH::DefinitionList.parse_first(@doc)
    assert_equal HMachine::POSH::DefinitionList, dl.class
  end
  
  should 'build a hash out of a definition list' do
    dl = HMachine::POSH::DefinitionList.find_in(@doc).first
    dict = HMachine::POSH::DefinitionList.build_dictionary(dl)
    assert dict.has_key?(:rel)
    assert !dict.has_key?(:script)
  end
  
  should 'parse a defintion list' do
    dl = HMachine::POSH::DefinitionList.parse_first(@doc)
    assert_respond_to dl, :to_h
    assert dl.to_h.has_key?(:rel)
    assert dl.to_h[:rel].has_key?(:script)
  end
  
  should 'list its properties as its hash representation' do
    dl = HMachine::POSH::DefinitionList.parse_first(@doc)
    assert_equal dl.to_h, dl.properties
  end
  
  should 'have key lookup methods' do
    dl = HMachine::POSH::DefinitionList.parse_first(@doc)
    assert_equal dl.to_h[:rel], dl[:rel]
  end
  
end