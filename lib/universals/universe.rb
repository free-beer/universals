#! /usr/bin/env ruby
#
# Copyright (c), 2012 Peter Wood
# See the license.txt for details of the licensing of the code in this file.

require 'singleton'

module Universals
   # The Universals class includes the Ruby Singleton mixin and provides a
   # single source location to store and retrieve data that is used across
   # the entirety of an application or libraries code base. This avoids having
   # to use global variables or to have to pass data elements around. The class
   # behaves very much like a Hash, mapping keys to values. The class also
   # makes the values stored within it available as properties, so all values
   # stored within a Universe must be stored under String keys with names that
   # conform to standard Ruby method naming criteria.
   class Universe
      # Mixin the singleton stuff.
      include Singleton
      
      # Mixin the enumerable stuff.
      include Enumerable
      
      # Constructor for the Universe class.
      def initialize
         @values = {}
      end

      # This method is used to check whether a property is stored under a given
      # key within a Universe object.
      #
      # ==== Parameters
      # key::  The key to perform the check for.
      def has_property?(key)
         @values.include?(key)
      end

      # This method fetches the value associated with a given key.
      #
      # ==== Parameters
      # key::      The key for the value to be retrieved.
      # default::  The default to return if the key does not exist within the
      #            Universe object. Defaults to nil.
      def get_property(key, default=nil)
         value = @values.fetch(key, default)
         if value.respond_to?(:call)
            value        = value.call
            @values[key] = value
         end
         value
      end

      # This method assigns a value under a specified key within a Universe
      # object. Existing entries will be overwritten by this method.
      def set_property(key, value)
         validate_name(key)
         @values[key] = value
      end

      # This method allows multiple values to be set on the Universe object
      # in a single request.
      #
      # ==== Parameters
      # values::  A Hash of the values to be set on the object. Keys should be
      #           adhere to the standard name requirements for the Universe
      #           object or an exception will be raised. Values specified in
      #           this way will override values already in the object.
      def set(values={})
         values.each {|name, value| set_property(name, value)}
      end

      # Implementation of the each() method for the Universe class.
      def each(&block)
         @values.each(&block)
      end

      # This method fetches a count of the number of items held within an
      # instance of the Universe class.
      def size
         @values.size
      end
      
      # This method fetches the key associated with a value stored in the
      # Universe instance.
      #
      # ==== Parameters
      # value::  The value to retrieve the key for.
      def key(value)
         @values.key(value)
      end
      
      # This method fetches a collection of the keys stored within a Universe
      # instance.
      def keys
         @values.keys
      end
      
      # This method fetches a collection of the values stored within a Universe
      # instance.
      def values
         @values.values
      end

      # This method deletes all entries from a Universe instance.
      def clear
         @values.clear
      end

      # This method overrides the default respond_to?() method to provide
      # customer property handling for Universe objects.
      #
      # ==== Parameters
      # name::  The name of the method to perform the check for.
      def respond_to?(name)
         @hash.include?(name) || super(name)
      end

      # This method is invoked whenever a method invocation takes place
      # against a Universe object but an existing explicit method cannot be
      # found to meet the call.
      #
      # ==== Parameters
      # name::       The name of the method invoked.
      # arguments::  A collection of the arguments passed to the method call.
      # block::      Any block associated with the method call.
      def method_missing(name, *arguments, &block)
         if @values.include?(name.to_s)
            get_property(name.to_s)
         elsif name.to_s[-1, 1] == "="
            property = name.to_s
            property = property[0, property.length - 1]
            set_property(property, arguments[0])
            self
         else
            super
         end
      end

      # Class aliases.
      alias :[] :get_property
      alias :[]= :set_property
      alias :include? :has_property?
      
      private
      
      # This method is used internally by the class to determine whether a key
      # is valid for use with a Universe object.
      def validate_name(name)
         if !name.kind_of?(String)
            raise UniversalsError.new("The key '#{name}' cannot be used in a "\
                                      "Universe object as it is not a String.")
         end
         
         if /^[a-zA-Z_]+[a-zA-Z_0-9]*[\?!]?$/.match(name).nil?
            raise UniversalsError.new("The key '#{name}' cannot be used in a "\
                                      "Universe object as it is not a valid "\
                                      "method name.")
         end
      end
   end
end