#! /usr/bin/env ruby
#
# Copyright (c), 2012 Peter Wood
# See the license.txt for details of the licensing of the code in this file.

require 'universals'
require 'pp'
require 'test/unit'
require 'yaml'

include Universals

class TestUniverse < Test::Unit::TestCase
   def setup
   end
   
   def teardown
      Universe.instance.clear
   end
   
   def test_has_property?
      universe = Universe.instance
      
      assert_equal(false, universe.has_property?("one"))
      assert_equal(false, universe.has_property?("two"))
      assert_equal(false, universe.has_property?("three"))
      
      universe.one   = "Blah"
      universe.three = "Ningy"
      
      assert_equal(true, universe.has_property?("one"))
      assert_equal(false, universe.has_property?("two"))
      assert_equal(true, universe.has_property?("three"))
   end
   
   def test_get_property
      universe = Universe.instance
      
      assert_nil(universe.get_property("one"))
      assert_nil(universe.get_property("two"))
      assert_equal("blah", universe.get_property("three", "blah"))
      
      universe.one   = "Blah"
      universe.three = "Ningy"
      
      assert_equal("Blah", universe.get_property("one"))
      assert_equal(123, universe.get_property("two", 123))
      assert_equal("Ningy", universe.get_property("three", "Bazinga"))
   end
   
   def test_set_property
      universe = Universe.instance
      
      universe.set_property("One", 1)
      universe.set_property("Two", "2")
      universe.set_property("Three", 3)
      
      assert_equal(1, universe.One)
      assert_equal("2", universe.Two)
      assert_equal(3, universe.Three)
      
      universe.set_property("Two", 3.14)
      assert_equal(3.14, universe.Two)
   end

   def test_set
      universe = Universe.instance

      universe.set("One" => 1, "Two" => "2", "Three" => 3)
      assert_equal(3, universe.size)
      assert_equal(1, universe.One)
      assert_equal("2", universe.Two)
      assert_equal(3, universe.Three)
   end
   
   def test_each
      universe = Universe.instance
      
      universe.set_property("One", 1)
      universe.set_property("Two", "2")
      universe.set_property("Three", 3)
      
      keys   = []
      values = []
      universe.each do |key, value|
         keys << key
         values << value
      end
      
      assert_equal(3, keys.size)
      assert_equal(3, values.size)
      assert_equal(true, keys.include?("One"))
      assert_equal(true, keys.include?("Two"))
      assert_equal(true, keys.include?("Three"))
      assert_equal(true, values.include?(1))
      assert_equal(true, values.include?("2"))
      assert_equal(true, values.include?(3))
   end
   
   def test_size
      universe = Universe.instance

      assert_equal(0, universe.size)

      universe.set_property("One", 1)
      assert_equal(1, universe.size)

      universe.set_property("Two", "2")
      assert_equal(2, universe.size)

      universe.set_property("Three", 3)
      assert_equal(3, universe.size)
   end

   def test_key
      universe = Universe.instance
      
      universe.set_property("One", 1)
      universe.set_property("Two", "2")
      universe.set_property("Three", 3)
      
      assert_equal("One", universe.key(1))
      assert_equal("Two", universe.key("2"))
      assert_equal("Three", universe.key(3))
   end

   def test_keys
      universe = Universe.instance
      
      assert_equal([], universe.keys)
      
      universe.set_property("One", 1)
      universe.set_property("Two", "2")
      universe.set_property("Three", 3)
      
      assert_equal(3, universe.keys.size)
      assert_equal(true, universe.keys.include?("One"))
      assert_equal(true, universe.keys.include?("Two"))
      assert_equal(true, universe.keys.include?("Three"))
   end

   def test_values
      universe = Universe.instance
      
      assert_equal([], universe.values)
      
      universe.set_property("One", 1)
      universe.set_property("Two", "2")
      universe.set_property("Three", 3)
      
      assert_equal(3, universe.values.size)
      assert_equal(true, universe.values.include?(1))
      assert_equal(true, universe.values.include?("2"))
      assert_equal(true, universe.values.include?(3))
   end
   
   def test_values_from_properties
      universe = Universe.instance

      universe.set_property("One", 1)
      universe.set_property("Two", "2")
      universe.set_property("_Three", 3)
      
      assert_equal(1, universe.One)
      assert_equal("2", universe.Two)
      assert_equal(3, universe._Three)
   end
   
   def test_invalid_key_names
      universe = Universe.instance

      assert_raises(UniversalsError) do
         universe.set_property("1_method", "blah")
      end

      assert_raises(UniversalsError) do
         universe.set_property("method-one", "blah")
      end

      assert_raises(UniversalsError) do
         universe.set_property("method[]", "blah")
      end

      assert_raises(UniversalsError) do
         universe.set_property("method=", "blah")
      end

      assert_raises(UniversalsError) do
         universe.set_property(123, "blah")
      end
   end
   
   def test_deferred_creation
      universe = Universe.instance
      
      universe.deferred = Proc.new do
         "Blah-de-blah"
      end
      assert_equal("Blah-de-blah", universe.deferred)
   end
end