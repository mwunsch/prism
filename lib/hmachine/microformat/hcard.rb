module HMachine
  module Microformat
    class HCard < POSH::Base
      WIKI_URL = "http://microformats.org/wiki/hcard"
      XMDP = 'http://microformats.org/profile/hcard'
      
      name :vcard
      
      has_one :fn, :bday, :tz, :sort_string, :uid, :rev 
      alias birthday bday
      
      has_many :agent, :category, :key, :label,
               :mailer, :nickname, :note, :role, :sound, 
               :title
                     
      has_many :logo, :photo, :url do
        extract :url
      end
      
      has_one :geo do
        extract :geo
      end
      
      has_many :email, :tel do
        extract :typevalue
      end
      
      has_many :adr do
        extract :adr
      end
      alias address adr
            
      has_many :org do
        has_one :organization_unit
        has_one :organization_name do
          search do |org|
            org_name = org.css(".organization-name")
            !org_name.empty? ? org_name : org
          end
        end        
      end
      
      has_one :n do
        search do |doc|
          n = doc.css(".#{name}")
          !n.empty? ? n : parent.properties[:fn].find_in(doc)
        end
        
        has_many :family_name, :given_name, :additional_name,
                  :honorific_prefix, :honorific_suffix
        
        extract do |node|
          if node.matches?(".#{name}")
            self.new(node)
          else
            # Has to be a smarter way of doing this
            parent.n_optimization(node)
          end
        end  
      end
      
      has_one! :class
      
      # N Optimization from Sumo:
      # http://www.danwebb.net/2007/2/9/sumo-a-generic-microformats-parser-for-javascript
      # See: http://microformats.org/wiki/hcard#Implied_.22n.22_Optimization
      def self.n_optimization(node)
        fn = properties[:fn].parse_first(node.parent)
        org = properties[:org].parse_first(node.parent)
        if (fn != org)
          if (fn =~ /^(\w+) (\w+)$/)
            { :given_name => Regexp.last_match[1],
              :family_name => Regexp.last_match[2] }
          elsif (fn =~ /^(\w+), (\w+)\.?$/)
            { :given_name => Regexp.last_match[2],
              :family_name => Regexp.last_match[1] }
          end
        end
      end
      
      def organization?
        fn == org[:organization_name]
      end
      alias company? organization?
      
      # http://tools.ietf.org/html/rfc2426
      # TODO: Make this less ugly
      def to_vcard
        @vcard = "BEGIN:VCARD\x0D\x0AVERSION:3.0\x0D\x0APRODID:#{HMachine::PRODID}"
        @vcard += "\x0D\x0ANAME:#{node.document.css('title').first.content}" if node.document.css('title').first
        @vcard += "\x0D\x0ASOURCE:#{@source}" if @source
        @vcard += "\x0D\x0AFN:#{fn}" if fn
        @vcard += n_vcard if n
        if nickname
          @vcard += "\x0D\x0ANICKNAME" + (nickname.respond_to?(:join) ? nickname.join(',') : nickname)
        end
        @vcard += "\x0D\x0APHOTO;VALUE=uri:#{photo.first}" if photo
        @vcard += "\x0D\x0ABDAY:#{bday.strftime('%Y-%m-%d')}" if bday
        if adr
          if adr.respond_to?(:each)
            adr.each { |address| @vcard += adr_vcard(address) }
          else
            @vcard += adr_vcard(adr)
          end           
        end
        if tel
          if tel.respond_to?(:join)
            tel.each { |phone| @vcard += "\x0D\x0ATEL#{type_value_vcard(phone)}" }
          else
            @vcard += "\x0D\x0ATEL#{type_value_vcard(phone)}"
          end
        end
        if email
          if email.respond_to?(:join)
            email.each { |mail| @vcard += "\x0D\x0AEMAIL#{type_value_vcard(mail)}" }
          else
            @vcard += "\x0D\x0AEMAIL#{type_value_vcard(email)}"
          end
        end
        mailer.each {|software| @vcard += "\x0D\x0AMAILER:#{software}" } if mailer
        @vcard += "\x0D\x0ATZ:#{tz}" if tz
        @vcard += "\x0D\x0AGEO:#{geo[:latitude]};#{geo[:longitude]}" if geo
        title.each {|titl| @vcard += "\x0D\x0ATITLE:#{titl}" } if title
        role.each {|roll| @vcard += "\x0D\x0AROLE:#{roll}" } if role
        logo.each { |log| @vcard += "\x0D\x0ALOGO;VALUE=uri:#{log}" } if logo
        agent.each {|mrsmith| @vcard += "\x0D\x0AAGENT:#{mrsmith}" } if agent
        @vcard += "\x0D\x0AORG:#{org[:organization_name]};#{org[:organization_unit]}" if org
        @vcard += "\x0D\x0ACATEGORIES:#{join_vcard_values(category).upcase}" if category
        note.each {|notes| @vcard += "\x0D\x0ANOTE:#{notes}" } if note
        @vcard += "\x0D\x0AREV:#{rev.iso8601}" if rev
        @vcard += "\x0D\x0ASORT-STRING:#{sort_string}" if sort_string
        sound.each {|audio| @vcard += "\x0D\x0ASOUND;VALUE=uri:#{audio}" } if sound
        @vcard += "\x0D\x0AUID:#{uid}" if uid
        url.each {|web| @vcard += "\x0D\x0AURL:#{web}" } if url
        @vcard += "\x0D\x0ACLASS:#{to_h[:class]}" if has_property?(:class)
        key.each {|auth| @vcard += "\x0D\x0AKEY:#{key}" }if key
        @vcard += "\x0D\x0AEND:VCARD\x0D\x0A\x0D\x0A"
      end
      
      private
      
        def join_vcard_values(values)
          values.respond_to?(:join) ? values.join(',') : values.to_s.strip
        end
        
        def type_value_vcard(communication)
          if communication.respond_to?(:keys)
            _comm = ";TYPE=#{join_vcard_values(communication[:type])}:#{communication[:value]}"
          else
            _comm = ":#{communication}"
          end
          _comm
        end
      
        def adr_vcard(address)
          addresses = "\x0D\x0AADR"
          adr_vcard = {}
          adr.to_h.each_pair { |key,value| adr_vcard[key] = join_vcard_values(value) }
          if address[:type]
            addresses += ";TYPE=" + (address[:type].respond_to?(:join) ? address[:type].join(',') : address[:type].to_s)
          end
          addresses += ":#{address[:post_office_box]};#{adr_vcard[:extended_address]};#{adr_vcard[:street_address]};"
          addresses += "#{adr_vcard[:locality]};#{adr_vcard[:region]};#{address[:postal_code]};#{adr_vcard[:country_name]}"
        end
      
        def n_vcard
          n_vcard = {}
          n.each_pair { |key,value| n_vcard[key] = join_vcard_values(value) }
          "\x0D\x0AN:#{n_vcard[:family_name]};#{n_vcard[:given_name]};#{n_vcard[:additional_name]};"+\
          "#{n_vcard[:honorific_prefix]};#{n_vcard[:honorific_suffix]}"
        end
            
    end
  end
end