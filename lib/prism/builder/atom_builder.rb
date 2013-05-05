require 'forwardable'

module Prism
  module Builder
    class AtomBuilder
      public

      def add_hatom(hatom)
        self.hatom = hatom
      end

     def build
        self.builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
          xml.feed('xmlns' => 'http://www.w3.org/2005/Atom') do
            entries.each do |hentry|
              build_entry xml, hentry
            end
          end
        end
        self
      end

     def to_s
        builder.to_xml
      end

      private

      attr_accessor :builder, :hatom

      def entries
        if hatom
          hatom.hentry || []
        else
          []
        end
      end

      class EntryDelgator
        extend Forwardable

        attr_reader :hentry

        def_delegator :hentry, :entry_title, :title
        def_delegator :hentry, :entry_summary, :summary

        def initialize(hentry)
          @hentry = hentry
        end

        def fields
          [:title, :updated, :published, :summary]
        end

        def updated
          hentry.updated.iso8601 if hentry.updated
        end

        def published
          hentry.published.iso8601 if hentry.published
        end
      end

      class AuthorDelegator
        extend Forwardable

        attr_reader :author

        def_delegator :author, :fn, :name
        def_delegator :author, :email

        def initialize(author)
          @author = author
        end

        def fields
          [:name, :uri, :email]
        end

        def uri
          author.url.first if author.url
        end
      end

      def build_entry(xml, hentry)
        entry = EntryDelgator.new(hentry)
        xml.entry do
          entry.fields.each do |field|
            xml.send(field, entry.send(field)) if entry.send(field)
          end
          if hentry.entry_content
            xml.content(:type => "html") do
              xml.text hentry.entry_content
            end
          end
          if hentry.author
            author = AuthorDelegator.new(hentry.author)
            xml.author do
              author.fields.each do |field|
                xml.send(field, author.send(field)) if author.send(field)
              end
            end
          end
        end
      end

    end
  end
end
