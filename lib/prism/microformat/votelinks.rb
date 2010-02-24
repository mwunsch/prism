module Prism
  module Microformat
    class VoteLinks < POSH::Anchor
      FRIENDLY_NAME = "VoteLinks"
      WIKI_URL = 'http://microformats.org/wiki/vote-links'
      XMDP = 'http://microformats.org/profile/vote-links'
      
      selector 'a[rev~="vote-for"], a[rev~="vote-against"], a[rev~="vote-abstain"]'
      
      validate do |a|
        return false unless a['rev']
        !%w(vote-for vote-against vote-abstain).reject { |vote|
          a['rev'].split.include?(vote)
        }.empty?
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