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

  # == Pouf#play_cmd == #

  def test_pouf_play_cmd_env_no_spaces
    s = 'some_random_command'
    ENV['POUF_CMD'] = s
    assert_equal([s], Pouf.play_cmd)
  end

  def test_pouf_play_cmd_env_with_spaces
    s = 'some random command'
    ENV['POUF_CMD'] = s
    assert_equal(%w[some random command], Pouf.play_cmd)
  end

  # == Pouf#filename2alias == #

  def test_pouf_filename2alias_empty
    assert_nil(Pouf.filename2alias(''))
  end

  def test_pouf_filename2alias_no_path
    n = 'foobar'
    assert_equal(n, Pouf.filename2alias("#{n}.ext"))
  end

  def test_pouf_filename2alias_with_dirs
    n = 'foobar'
    assert_equal(n, Pouf.filename2alias("foo/bar/#{n}.ext"))
  end

  def test_pouf_filename2alias_absolute_path
    n = 'foobar'
    assert_equal(n, Pouf.filename2alias("/foo/bar/#{n}.ext"))
  end

  def test_pouf_filename2alias_relative_path
    n = 'foobar'
    assert_equal(n, Pouf.filename2alias("../bar/#{n}.ext"))
    assert_equal(n, Pouf.filename2alias("./bar/#{n}.ext"))
  end

end


exit Test::Unit::AutoRunner.run
