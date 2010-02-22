require 'hmachine/pattern/url'
require 'hmachine/pattern/datetime'
require 'hmachine/pattern/abbr'
require 'hmachine/pattern/valueclass'
require 'hmachine/pattern/typevalue'

module HMachine
  module Pattern
    
    def self.map(name)
      case HMachine.normalize(name)
        when :value_class, :valueclass
          HMachine::Pattern::ValueClass
        when :abbr
          HMachine::Pattern::Abbr
        when :uri, :url
          HMachine::Pattern::URL
        when :typevalue
          HMachine::Pattern::TypeValue
        else
          raise "#{name} is not a recognized markup design pattern."
      end
    end
    
  end
end