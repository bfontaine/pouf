# -*- coding: UTF-8 -*-

require 'tmpdir'
require 'fileutils'

class PoufCommandsTests < Test::Unit::TestCase

  def setup
    @prev_cmd = ENV['POUF_CMD']
    ENV['POUF_CMD'] = 'echo'
    @prev_dir = Pouf.sounds_dir
    Pouf.sounds_dir = @sounds_dir = Dir.mktmpdir('pouf-tests')
  end

  def teardown
    Pouf.sounds_dir = @prev_dir
    FileUtils.rm_rf @sounds_dir
    ENV['POUF_CMD'] = @prev_cmd
  end

  # == Pouf#alias2filename == #
  
  def test_pouf_alias2filename_empty
    assert_nil(Pouf.alias2filename('foo'))
  end

  def test_pouf_alias2filename_one_file_no_extension
    f = "#{@sounds_dir}/foo"
    FileUtils.touch f
    assert_nil(Pouf.alias2filename('foo'))
  end

  def test_pouf_alias2filename_one_file_extension
    f = "#{@sounds_dir}/foo.bar"
    FileUtils.touch f
    assert_equal(f, Pouf.alias2filename('foo'))
  end

  def test_pouf_alias2filename_one_file_prefix
    f = "#{@sounds_dir}/foobar"
    FileUtils.touch f
    assert_nil(Pouf.alias2filename('foo'))
  end

  def test_pouf_alias2filename_two_files_same_basename
    f = "#{@sounds_dir}/foo.bar"
    FileUtils.touch f
    FileUtils.touch "#{@sounds_dir}/foo.qux"
    assert_equal(f, Pouf.alias2filename('foo'))
  end

  # == Pouf#init == #

  def test_pouf_init_dir_exists
    assert_equal(@sounds_dir, Pouf.init[0])
  end

  def test_pouf_init_dir
    d = "#{@sounds_dir}/foo"
    Pouf.sounds_dir = d
    assert_equal(d, Pouf.init[0])
    assert(Dir.exists?(d))
  end

end
