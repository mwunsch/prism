require 'time'
require 'parsedate'

module HMachine
  module Pattern
    module DateTime
      extend HMachine
      
      validate do |time|
        datetime = ParseDate.parsedate(time) 
        begin
          Time.local(*datetime).respond_to?(:iso8601)
        rescue
          !datetime.compact.empty?
        end
      end
      
      extract do |datetime|
        Time.parse(datetime)
      end     
      
    end
  end
end