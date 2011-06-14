require 'yaml'
require 'prism/microformat'

module Prism
  class POSH
    extend Prism
    
    def self.name(root=nil)
      @name = Prism.normalize(root) if root
      @name
    end
    
    def self.selector(css=nil)
      @selector = css if css
      @selector
    end
    
    def self.parent(owner=nil)
      @parent = owner.respond_to?(:extract) ? owner : Prism.map(owner) if owner
      @parent
    end
          
    def self.inherited(subclass)
      inheritable = [ :@properties, :@has_one, :@has_many, :@search, 
                      :@extract, :@validate, :@requirements ]
      inheritable.each do |var|
        subclass.instance_variable_set(var, instance_variable_get(var).dup) if instance_variable_get(var)
      end

      # Register any inherited microformats
      # FIX: The following isn't exactly bulletproof
      if subclass.to_s =~ /.*::Microformat::.*/
        subclass_symbol = subclass.to_s.sub(/.*::/, '').downcase.to_sym
        Microformat.register(subclass_symbol, subclass)
      end
    end

    # Instead of getting the contents of a node, this creates
    # a POSH format from the node
    def self.extract(*patterns, &block)
      if !@extract
        case
        when patterns.size == 1
          @extract = Prism.map(patterns.first).extract
        when patterns.size > 1
          @extract = lambda {|node| find_one_of(node, *patterns)}
        when block_given?
          @extract = block
        when properties.empty?
          @extract = Prism::Pattern::ValueClass.extract
        end
      end
      @extract || lambda{|node| self.new(node) } 
    end

    # Finds the first matching pattern in the node
    def self.find_one_of(node, *patterns)
      value = nil
      patterns.each do |pattern|
        pattern_class = Prism.map(pattern)
        name = Prism.normalize(pattern_class.name).to_s
        if node['class'].split.include?(name) ||
           [:valueclass, :url, :typevalue].include?(pattern)
          if (value = pattern_class.extract_from(node))
            break
          end
        end
      end
      value
    end

    def self.search(&block)
      @search = block if block_given?
      @search || lambda do |node|
        if selector
          node.css(selector)
        elsif name
          node.css(".#{name}".gsub('_','-'))
        else
          node
        end
      end
    end
    
    def self.validate(&block)
      @validate = block if block_given?
      @validate || lambda {|node| selector ? node.matches?(selector) : found_in?(node.parent) }
    end
    
    def self.add_property(property_name, &block)
      if property_name.respond_to?(:property_of?)
        property = property_name
      else
        property = Class.new(Prism::POSH::Base)
        property.name property_name
        property.parent self
        property.instance_eval(&block) if block_given?
      end
      properties[property.name] = property
      property
    end
    
    def self.properties
      @properties ||= {}
    end

    def self.[](key)
      properties[key]
    end

    def self.property_of?(format)
      Prism.map(format) == parent
    end

    def self.has_one(*property_names, &block)
      property_names.collect do |name|
        property = has_one!(name, &block)
        define_method property.name do 
          self[property.name]
        end
        property
      end
    end

    def self.has_many(*property_names, &block)
      property_names.collect do |name|
        property = has_many!(name, &block)
        define_method property.name do 
          self[property.name]
        end
        property
      end
    end

    def self.has_one!(property_name, &block)
      @has_one ||= []
      property = add_property(property_name, &block)
      @has_one << property
      property
    end

    def self.has_many!(property_name, &block)
      @has_many ||= []
      property = add_property(property_name, &block)
      @has_many << property
      property
    end
    
    def self.one
      @has_one
    end
    
    def self.many
      @has_many
    end
    
    def self.requirements
      @requirements ||= []
    end

    # Remove a format from a node if it is nested.
    def self.remove_nested(node)
      if (find_in(node) != node)
        find_in(node).unlink if found_in?(node)
      end
      node
    end
    
    def self.get_properties(node, props=properties)
      hash ||= {}
      props.each_pair do |key, property|
        hash[key] = if one && one.include?(property)
          property.parse_first(node)
        else
          property.parse(node)
        end
      end
      hash.reject do |key,value| 
        value.respond_to?(:empty?) ? value.empty? : value.nil?
      end
    end
    
    def self.required!
      parent.requirements << self if parent
    end
            
    attr_reader :node, :parent, :source
    
    def initialize(node, parent=nil)
      raise 'Uh OH' unless self.class.valid?(node)
      @node = node
      @source = node.document.url if node.document.url
      @parent = parent if parent
      @first_node = self.class.remove_nested(node.dup)
    end
    
    def [](property_key)
      @get_properties ||= self.class.get_properties(@first_node, properties)
      @get_properties[property_key]
    end
    
    def properties
      @properties ||= self.class.properties.reject { |key, property|
        !property.found_in?(@first_node)
      }
    end
    
    def to_h
      return @to_h if @to_h
      @get_properties ||= self.class.get_properties(@first_node, properties)
      @to_h = {}
      @get_properties.each_pair do |key,value|
        @to_h[key] = if value.respond_to?(:to_h)
          value.to_h
        elsif value.respond_to?(:flatten)
          value.map {|v| v.respond_to?(:to_h) ? v.to_h : v }
        else
          value
        end
      end
      @to_h
    end
    
    def to_yaml
      to_h.to_yaml
    end
    
    def inspect
      to_h.inspect
    end
    
    def has_property?(key)
      to_h.has_key?(key)
    end
    
    def to_s
      node.to_s
    end
    
    def to_html
      node.to_html
    end
    
    def empty?
      to_h.empty?
    end
    
    def each_pair(&block)
      to_h.each_pair(&block)
    end

  end
end

require 'prism/posh/base'
require 'prism/posh/anchor'
require 'prism/posh/definition_list'
