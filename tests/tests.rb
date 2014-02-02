#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'coveralls'
Coveralls.wear!

require 'test/unit'
require 'simplecov'

test_dir = File.expand_path( File.dirname(__FILE__) )

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start { add_filter '/tests/' }

require 'pouf'

for t in Dir.glob( File.join( test_dir,  '*_tests.rb' ) )
  require t
end

class PoufTests < Test::Unit::TestCase

  # == Pouf#version == #

  def test_pouf_version
    assert(Pouf.version =~ /^\d+\.\d+\.\d+/)
  end

end


exit Test::Unit::AutoRunner.run
