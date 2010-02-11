# hMachine

**Ruby microformat parser and HTML toolkit**

It is not even close to ready, yet.

## Requirements

+ [Nokogiri](http://github.com/tenderlove/nokogiri)

## What hMachine should/will be:

+ A robust microformat parser
+ A CLI for fetching microformats from a url or a string of html
+ A DSL for defining semantic markup patterns
+ Export microformats to other standards. hCard => vCard.
+ HTML outlininer (using HTML5 sectioning)
+ Extensions so you can do something like: `String.is_a_valid? :hcard` in your tests
+ Extensions to turn Ruby objects into semantic HTML. Hash.to_definition_list, Arrays.to_ordered_list, etc. 

Maybe more than that. It should be your lowercase semantic web friend.

## Microformats supported (right now, as of this very moment)

+ [rel-tag](http://microformats.org/wiki/rel-tag)
+ [rel-license](http://microformats.org/wiki/rel-license)
+ [VoteLinks](http://microformats.org/wiki/vote-links)
+ [XFN](http://microformats.org/wiki/XFN)
+ [XOXO](http://microformats.org/wiki/xoxo)
+ [XMDP](http://microformats.org/wiki/XMDP)
+ [geo](http://microformats.org/wiki/geo)

Working on hCard.

## POSH DSL

The `HMachine` module defines a group of methods to search, validate, and extract nodes out of a Nokogiri document.

All microformats inherit from `HMachine::POSH::Base`, because all microformats begin as [POSH formats](http://microformats.org/wiki/posh). If you wanted to create your own POSH format, you'd do something like this:

	class Navigation < HMachine::POSH::Base
		search {|document| document.css('ul#navigation') }
		# Search a Nokogiri document for nodes of a certain type
		
		validate {|node| node.matches?('ul#navigation') }
		# Validate that a node is the right element we want
		
		has_many :items do |items|
			items.search {|doc| doc.css('li') }
		end
		# has_many and has_one define Properties of the POSH format (HMachine::Property)
		# Each Property object includes the HMachine module, so they can search, validate, and extract
	end
	
Now you can do:

	nav = Navigation.parse_first(document) 
	# document is a Nokogiri document. 
	# parse_first extracts just the first example of the format out of the document
	
	nav.items
	# Returns an array of contents
	# This method comes from the has_many call up above that defines the Property

## License

hMachine is licensed under the [MIT License](http://creativecommons.org/licenses/MIT/) and is Copyright (c) 2010 Mark Wunsch.