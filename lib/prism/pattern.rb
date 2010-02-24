require 'prism/pattern/url'
require 'prism/pattern/datetime'
require 'prism/pattern/abbr'
require 'prism/pattern/valueclass'
require 'prism/pattern/typevalue'

module Prism
  module Pattern
    
    def self.map(name)
      case Prism.normalize(name)
        when :value_class, :valueclass
          Prism::Pattern::ValueClass
        when :abbr
          Prism::Pattern::Abbr
        when :uri, :url
          Prism::Pattern::URL
        when :typevalue
          Prism::Pattern::TypeValue
        else
          raise "#{name} is not a recognized markup design pattern."
      end
    end
    
  end
end