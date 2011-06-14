module Prism
  module Microformat
    class HCalendar < POSH
      FRIENDLY_NAME = "hCalendar"
      WIKI_URL = "http://microformats.org/wiki/hcalendar"
      XMDP = 'http://microformats.org/profile/hcalendar'
      
      name :vcalendar
      
      search do |doc|
        vcalendar = doc.css("#{name}")
        if vcalendar.empty? && !doc.css('.vevent').empty?
          doc
        else
          vcalendar
        end
      end
      
      has_many :vevent do
        has_one(:dtstart, :summary) { required! }
        
        has_one :duration, :dtend, :location, :description, :dtstamp,
                :last_modified, :uid, :status, 
                :geo
        
        has_one(:contact, :organizer) do
          extract :hcard, :valueclass
        end

        has_one(:url) { extract :url }
        
        has_many :category
        
        has_many(:attendee) do
          extract :hcard, :valueclass
        end
        
        has_one! :class
        
        required!
      end
      
    end
  end
end
