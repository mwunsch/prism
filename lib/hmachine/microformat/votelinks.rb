module HMachine
  module Microformat
    class VoteLinks < Base
      
      wiki_url 'http://microformats.org/wiki/vote-links'
      
      search do |doc| 
        doc.css('a[rev~="vote-for"], a[rev~="vote-against"], a[rev~="vote-abstain"]')
      end
      
      validate do |a|
        return false unless a['rev']
        validator = %w(vote-for vote-against vote-abstain).reject do |vote|
          a['rev'].split(' ').include?(vote)
        end
        !validator.empty?
      end
      
      def vote
        @vote ||= { type => [url, title].compact }
      end
      
      def type
        vote_type = node['rev'].split(' ').reject do |vote| 
          vote.index('vote-') != 0
        end
        vote_type.first
      end
      
      def title
        node['title']
      end
      
      def url
        node['href']
      end
      
      def for?
        type == 'vote-for'
      end
      
      def against?
        type == 'vote-against'
      end
      
      def abstain?
        type == 'vote-abstain'
      end
      
    end
  end
end