module Prism
  module Microformat
    class HAtom < POSH
      FRIENDLY_NAME = "hAtom"
      WIKI_URL = "http://microformats.org/wiki/hatom"
      XMDP = 'http://microformats.org/profile/hatom'

      name :hfeed

      search do |doc|
        hfeed = doc.css("#{name}")
        if hfeed.empty? && !doc.css('.hfeed').empty?
          doc
        else
          hfeed
        end
      end

      #TODO move to reltags
      has_many :category do
        search do |node|
          node.css('a[rel~="tag"]')
        end
        extract do |node|
          node['href'].split('/').last
        end
      end

      has_many :hentry do
        has_one :entry_title do
          search do |node|
            entry_title = node.css(".entry-title")
            if entry_title.empty?
              entry_title = node.css("h1,h2,h3,h4,h5,h6")
            end
            entry_title
          end
        end
        has_one :entry_summary

        has_one :updated, :published do
          extract :typevalue
        end

        has_one :author do
          extract :hcard
        end

        has_one :entry_content do
          extract do |node|
            node.inner_html.strip
          end
        end

        #TODO move to reltags
        has_many :tags do
          search do |node|
            node.css('a[rel~="tag"]')
          end
          extract do |node|
            node['href'].split('/').last
          end
        end

        has_one :bookmark do
          search do |node|
            node.css('a[rel~="bookmark"]')
          end
          extract do |node|
            node['href']
          end
        end

        required!
      end

      def to_atom
        builder = Prism::Builder::AtomBuilder.new(self)
        builder.build
        builder.to_s
      end

    end
  end
end
