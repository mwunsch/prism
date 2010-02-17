require 'hmachine/pattern/url'
require 'hmachine/pattern/datetime'
require 'hmachine/pattern/abbr'
require 'hmachine/pattern/valueclass'
require 'hmachine/pattern/typevalue'

module HMachine
  module Pattern
    
    def self.map(name)
      case name.to_s.strip.downcase.intern
        when :value_class, :valueclass
          ValueClass
        when :abbr
          Abbr
        when :uri, :url
          URL
        when :typevalue
          TypeValue
        else
          raise "#{name} is not a recognized markup design pattern."
      end
    end
    
  end
end