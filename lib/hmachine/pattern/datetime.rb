require 'time'
require 'parsedate'

module HMachine
  module Pattern
    module DateTime
      extend HMachine
      
      validate do |time|
        !ParseDate.parsedate(time).compact.empty?
      end
      
      extract do |datetime|
        Time.parse(datetime)
      end     
      
    end
  end
end