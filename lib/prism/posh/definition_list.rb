module Prism
  class POSH
    class DefinitionList < POSH
      
      selector 'dl'
      
      extract {|dl| self.new(dl) }
      
      def self.build_dictionary(dl)
        dictionary = {}
        terms = dl.children.select {|dt| dt.elem? && dt.node_name.eql?('dt') }
        terms.each do |term|
          definition = term.next_element if term.next_element.node_name.eql?('dd')
          nested_dls = definition.children.select {|dd| dd.elem? && dd.node_name.eql?('dl') } 
          if nested_dls.empty?
            value = definition.content.strip
          elsif nested_dls.length.eql?(1)
            value = build_dictionary(nested_dls.first)
          else
            # if there are multiple nested <dl> elements, merge them together
            value = {}
            nested_dls.each do |dict| 
              value.merge! build_dictionary(dict) 
            end
          end
          dictionary[term.content.strip.intern] = value
        end
        dictionary
      end
      
      def [](key)
        to_h[key]
      end
      
      def properties
        to_h
      end
      
      def to_h
        @to_h ||= self.class.build_dictionary(node)
      end
      
    end
  end
end