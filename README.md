# Prism

**Ruby microformat parser and HTML toolkit**

[RDoc](http://rdoc.info/projects/mwunsch/prism) | [Gem](http://rubygems.org/gems/prism) | [Metrics](http://getcaliper.com/caliper/project?repo=git%3A%2F%2Fgithub.com%2Fmwunsch%2Fprism.git) | [Microformats.org](http://microformats.org/wiki/Prism)

## What Prism is:

+ A robust microformat parser
+ A command-line tool for parsing microformats from a url or a string of markup
+ A DSL for defining semantic markup patterns
+ Export microformats to other standards:
	+ hCard => vCard

It is your [lowercase semantic web](http://tantek.com/presentations/2004etech/realworldsemanticspres.html) friend.

>Designed for humans first and machines second, microformats are a set of simple, open data formats built upon existing and widely adopted standards. Instead of throwing away what works today, microformats intend to solve simpler problems first by adapting to current behaviors and usage patterns (e.g. XHTML, blogging).

Learn more about Microformats at http://microformats.org.

## Usage

The command line tool takes a SOURCE from the Standard Input or as an argument:

	$: curl http://markwunsch.com | prism --hcard > ~/Desktop/me.vcf
	
OR

	$: prism --hcard http://markwunsch.com > ~/Desktop/me.vcf

## Installation

With Ruby and Rubygems:

	gem install prism
	
Or clone the repository and run `bundle install` to get the development dependencies.	

#### Requirements:

+ [Nokogiri](http://github.com/tenderlove/nokogiri)

## Microformats supported (right now, as of this very moment)

+ [rel-tag](http://microformats.org/wiki/rel-tag)
+ [rel-license](http://microformats.org/wiki/rel-license)
+ [VoteLinks](http://microformats.org/wiki/vote-links)
+ [XFN](http://microformats.org/wiki/XFN)
+ [XOXO](http://microformats.org/wiki/xoxo)
+ [XMDP](http://microformats.org/wiki/XMDP)
+ [geo](http://microformats.org/wiki/geo)
+ [adr](http://microformats.org/wiki/adr)
+ [hCard](http://microformats.org/wiki/hcard)

More on the way.

## Finding Microformats:
	
	# All microformats
	Prism.find 'http://foobar.com'
	
	# A specific microformat
	Prism.find 'http://foobar.com', :hcard
	
	# Search HTML too
	Prism.find big_string_of_html
	
### Parsing Microformats:

	twitter_contacts = Prism.find 'http://twitter.com/markwunsch', :hcard
	me = twitter_contacts.first
	me.fn
	#=> "Mark Wunsch"
	me.n.family_name
	#=> "Wunsch"
	me.url
	#=> ["http://markwunsch.com/"]
	File.open('mark.vcf','w') {|f| f.write me.to_vcard }
	## Add me to your address book!	

## POSH DSL

The `Prism` module defines a group of methods to search, validate, and extract nodes out of a Nokogiri document.

All microformats inherit from `Prism::POSH`, because all microformats begin as [POSH formats](http://microformats.org/wiki/posh). If you wanted to create your own POSH format, you'd do something like this:

	class Navigation < Prism::POSH
		search {|document| document.css('ul#navigation') }
		# Search a Nokogiri document for nodes of a certain type
		
		validate {|node| node.matches?('ul#navigation') }
		# Validate that a node is the right element we want
		
		has_many :items do
			search {|doc| doc.css('li') }
		end
		# has_many and has_one define properties, which themselves inherit from
		# Prism::POSH::Base, so you can do :has_one, :has_many, :search, :extract, etc.
	end
	
Now you can do:

	nav = Navigation.parse_first(document) 
	# document is a Nokogiri document. 
	# parse_first extracts just the first example of the format out of the document
	
	nav.items
	# Returns an array of contents
	# This method comes from the has_many call up above that defines the :items property

## Other Microformat parsers

+ [Mofo](http://mofo.rubyforge.org/) is a Ruby microformat parser backed by Hpricot.
+ [Sumo](http://www.danwebb.net/2007/2/9/sumo-a-generic-microformats-parser-for-javascript) is a JavaScript microformat parser.
+ [Operator](https://addons.mozilla.org/en-US/firefox/addon/4106) is a Firefox extension.
+ [hKit](http://code.google.com/p/hkit/) is a microformat parser for PHP.
+ [Oomph](http://visitmix.com/labs/oomph/) is a microformat toolkit add-in for Internet Explorer.
	
## Feature wishlist:

+ HTML outliner (using HTML5 sectioning)
+ HTML5 article, time, etc POSH support
+ Extensions so you can do something like: `String.is_a_valid? :hcard` in your tests
+ Extensions to turn Ruby objects into semantic HTML. Hash.to_definition_list, Array.to_ordered_list, etc.	
	
## TODO:

+ Code is ugly. Especially XOXO.
+ Better recursive parsing of trees. See above.
+ Tests are all kinds of disorganized. And slow.
+ Broader support for some of the weirder Patterns, like object[data]
+ Man pages (see [Ron](http://github.com/rtomayko/ron))

## License

Prism is licensed under the [MIT License](http://creativecommons.org/licenses/MIT/) and is Copyright (c) 2010 Mark Wunsch.