#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'fileutils'

module Pouf
  class << self

    SOUNDS_DIR = File.expand_path("~/.pouf/sounds")

    def version
      '0.1.0'
    end

    def play_sound filename
      # only OSX for now
      system 'afplay', filename if filename
    end

    def alias2filename name
      Dir["#{SOUNDS_DIR}/#{name}.*"].first
    end

    def filename2alias fname
      fname =~ /(?:.*?\/)?(.+)\.\w+$/
      $1
    end

    ## Actions ##

    def add name, fname
      fname =~ /.+\.(\w+)$/
      ext = $1

      FileUtils.cp fname, "#{SOUNDS_DIR}/#{name}.#{ext}"
    end

    def init
      FileUtils.mkdir_p SOUNDS_DIR
    end

    def list
      Dir.entries(SOUNDS_DIR).map { |f| filename2alias f }
    end

    def mv from, to
      f1 = alias2filename from
      f2 = alias2filename to

      FileUtils.mv f1, f2
    end

    def play *aliases
      aliases.each { |a| play_sound (alias2filename a).first }
    end

    def rm *names
      names.each do |n|
        fs = alias2filenames n
        if fs
          FileUtils.rm fs
        else
          puts "Warning: No sound found for '#{n}'."
        end
      end
    end

  end
end
