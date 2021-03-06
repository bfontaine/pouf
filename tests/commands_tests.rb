# -*- coding: UTF-8 -*-

require 'tmpdir'
require 'fileutils'

class PoufCommandsTests < Test::Unit::TestCase
  include PoufTestsUtils

  def setup
    @prev_cmd = ENV['POUF_CMD']
    ENV['POUF_CMD'] = 'echo'
    @prev_dir = Pouf.sounds_dir
    @prev_path = Dir.pwd
    Pouf.sounds_dir = @sounds_dir = Dir.mktmpdir('pouf-tests')
    Dir.chdir Dir.mktmpdir('pouf-tests')
  end

  def teardown
    Pouf.sounds_dir = @prev_dir
    FileUtils.rm_rf @sounds_dir
    ENV['POUF_CMD'] = @prev_cmd
    Dir.chdir @prev_path
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

  # == Pouf#list == #

  def test_pouf_list_empty
    assert_equal([], Pouf.list)
  end

  def test_pouf_list
    fs = ['foo', 'bar', 'qux']
    fs.each { |f| FileUtils.touch "#{@sounds_dir}/#{f}.ext" }
    assert_equal(fs.sort, Pouf.list.sort)
  end

  # == Pouf#mv == #

  def test_pouf_mv
    a1, a2 = 'foo', 'bar'

    FileUtils.touch "#{@sounds_dir}/#{a1}.ext"

    assert_nothing_raised { Pouf.mv a1, a2 }
    assert(File.exists?("#{@sounds_dir}/#{a2}.ext"))
    assert(!File.exists?("#{@sounds_dir}/#{a1}.ext"))
  end

  # == Pouf#rm == #

  def test_pouf_rm_one_file
    a = 'foo'
    f = "#{@sounds_dir}/#{a}.ext"
    FileUtils.touch f

    assert_nothing_raised { Pouf.rm a }
    assert(!File.exists?(f))
  end

  def test_pouf_rm_files
    a = ['foo', 'bar', 'qux']
    f = a.map { |e| "#{@sounds_dir}/#{e}.ext" }
    f.map { |e| FileUtils.touch e }

    assert_nothing_raised { Pouf.rm *a }
    assert(!File.exists?(f[0]))
    assert(!File.exists?(f[-1]))
  end

  def test_pouf_rm_wrong_alias
    _stderr = $stderr
    $stderr = StringIO.new

    assert_nothing_raised { Pouf.rm 'unknown-alias' }
    assert_equal("Warning: No sound found for 'unknown-alias'.\n", $stderr.string)

    $stderr = _stderr
  end

  # == Pouf#play_sound == #

  def test_pouf_play_sound_with_cmd
    f = "#{@sounds_dir}/foo.ext"
    assert_nothing_raised { Pouf.play_sound f, %w[touch] }
    assert(File.exists?(f))
  end

  def test_pouf_play_sound_unsupported_no_cmd
    override_ruby_platform 'unsupported'
    ENV['POUF_CMD'] = nil
    _stderr = $stderr
    $stderr = StringIO.new

    assert_nothing_raised { Pouf.play_sound "#{@sounds_dir}/foo.ext" }
    assert_equal("pouf is unsupported for your platform for now\n", $stderr.string)

    $stderr = _stderr
    reset_ruby_platform
  end

  # == Pouf#add == #

  def test_pouf_add
    a   = 'bar'
    ext = 'ext'
    content = 'hello'
    source = "foo.#{ext}"
    dest = "#{@sounds_dir}/#{a}.#{ext}"
    File.open(source, 'w') { |f| f.write(content) }
    assert_nothing_raised { Pouf.add a, source }

    assert(File.exists?(source), 'it should preserve the original file')
    assert(File.exists?(dest))
    assert_equal(content, File.read(dest))
  end

  # == Pouf#play == #

  def test_pouf_play
    assert_nothing_raised { Pouf.play "unexisting-alias" }
  end

end
