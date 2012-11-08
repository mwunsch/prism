require 'time'

module Prism
  module Pattern
    module DateTime
      extend Prism
      
      # Is this string a simple date?
      def self.date?(string)
        !date(string).nil?
      end
      
      # Is this string a simple time?
      def self.time?(string)
        !time(string).nil?
      end
      
      # Normalize ISO8601 Dates
      def self.date(datestring)
        datetime = Date._parse(datestring)
        if !datetime.empty? && datetime[:year] && (datetime[:mon] || datetime[:yday])
          local = Time.now
          year = datetime[:year] || local.year
          if datetime[:yday]
            ordinal = Date.ordinal(year, datetime[:yday]) rescue nil
            if ordinal
              month = ordinal.month
              day = ordinal.day
            end
          else
            month = datetime[:mon] || local.month
            day = datetime[:mday] || 1
          end
          "#{year}-#{month}-#{day}" if (month && day)
        end
      end
      
      # Normalize ISO8601 Times
      def self.time(timestring)
        datetime = Date._parse(timestring)
        if !datetime.empty? && datetime[:hour]
          local = Time.now
          hour = datetime[:hour]
          min = datetime[:min] || 0
          sec = datetime[:sec] || 0
          zone = datetime[:zone] || local.zone
          "T#{hour}:#{min}:#{sec}#{zone}"
        end
      end
      
      # Build a normalized iso8601 datetime string
      def self.iso8601(datetime)
	# Extra validation added by Nimlhug: If the date contains 1 space, date and time are required.
	# If more than one space is present, it's invalid. Without this extra step certain other numbers
	# like phone numbers could be considered dates. Bad.
	# Note that these only apply if the dates are all-"numeric" ^(\+|-)?[0-9 :_-]+$

        datestamp = date(datetime) || ''
        timestamp = time(datetime) || ''

	if datetime =~ /^(\+|-)?[0-9 :_-]+$/ then
		spaces = datetime.strip.count(' ')
		if spaces > 1 then
			return ''
		end

		if spaces == 1 && (datestamp.nil? || timestamp.nil?) then
			return ''
		end
	end

	datestamp + timestamp
      end
      
      validate do |datetime|
        if !iso8601(datetime).empty?
          begin
            Time.parse(iso8601(datetime)).respond_to?(:iso8601)
          rescue ArgumentError
            # An out-of-bounds error means a false positive
            false
          end
        end
      end
      
      extract do |datetime|
        Time.parse(iso8601(datetime))
      end     
      
    end
  end
end
