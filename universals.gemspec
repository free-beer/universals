# Copyright (c) 2011, Peter Wood
# All rights reserved.
require File.expand_path('../lib/universals/version', __FILE__)

spec = Gem::Specification.new do |s|
   s.name        = "universals"
   s.version     = Universals::VERSION
   s.platform    = Gem::Platform::RUBY
   s.authors     = ["Black North"]
   s.email       = "ruby@blacknorth.com"
   s.summary     = "A library to provide a source for application wide data."
   s.description = "Universals provides a simple singleton class that can be used to store and retrieve data that is used throughout and application and thereby avoid global variables."
   s.homepage    = "https://github.com/free-beer/Universals"

   s.files        = Dir.glob("{bin,lib}/**/*") + %w(license.txt README)
   s.require_path = 'lib'
end