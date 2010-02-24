require 'hmachine/pattern/url'
require 'hmachine/pattern/datetime'
require 'hmachine/pattern/abbr'
require 'hmachine/pattern/valueclass'
require 'hmachine/pattern/typevalue'

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