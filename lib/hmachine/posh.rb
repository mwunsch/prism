module HMachine
  module POSH
    include HMachine
    
    attr_reader :name, :parent
    
    def properties
      @properties ||= {}
    end
    
    def [](key)
      properties[key]
    end
    
    def property_of?(format)
      HMachine.map(format) == parent
    end
    alias child_of? property_of?
    
    # Override extract to grok subproperties
    def extract(pattern = nil, &block)
      if !properties.empty?
        @extract = lambda do |node|
          props = {}
          properties.each_pair do |key, property|
            if @has_one && @has_one.include?(property)
              props[key] = property.parse_first(node)
            else
              props[key] = property.parse(node)
            end
          end
          props
        end
      elsif block_given?
        @extract = block
      elsif pattern
        @extract = HMachine.map(pattern).extract
      end
      @extract || lambda{|node| node.content.strip }
    end

    # Remove a format from a node if it is nested.
    def remove_nested(node)
      if (find_in(node) != node)
        find_in(node).unlink if found_in?(node)
      end
      node
    end
    
    def add_property(property_name, block=nil)
      if property_name.respond_to?(:property_of?)
        property = property_name
      else
        property = Property.new(property_name, self)
        block.call(property) if block
      end
      properties[property.name] = property
      property
    end
    
    def has_one(*property_names, &block)
      property_names.collect do |name|
        property = has_one!(name, block)
        property
      end
    end
    
    def has_many(*property_names, &block)
      property_names.collect do |name|
        property = has_many!(name, block)
        property
      end
    end
    
    def has_one!(property_name, function=nil, &block)
      block = function if (block.nil? && function)
      @has_one ||= []
      property = add_property(property_name, block)
      @has_one << property
      property
    end
    
    def has_many!(property_name, function=nil, &block)
      block = function if (block.nil? && function)
      @has_many ||= []
      property = add_property(property_name, block)
      @has_many << property
      property
    end
    
  end
end

require 'hmachine/property'
require 'hmachine/posh/base'
require 'hmachine/posh/anchor'
require 'hmachine/posh/definition_list'