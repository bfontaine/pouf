#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'fileutils'

module Pouf
  class << self

    SOUNDS_DIR = File.expand_path("~/.pouf/sounds")

    def version
      '0.1.1'
    end

    def play_cmd
      return ENV['POUF_CMD'].split(' ') if ENV['POUF_CMD']
      case RUBY_PLATFORM
      when /darwin/ then ['afplay']
      when /linux/  then ['mpg123', '-q']
      else nil
      end
    end

    def play_sound filename, cmd=nil
      return unless filename

      cmd ||= play_cmd

      if cmd
        system *cmd, filename
      else
        puts 'pouf is unsupported for your platform for now'
      end

    end

    def alias2filename name
      fns = Dir["#{SOUNDS_DIR}/#{name}.*"]
      fns.first if fns
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
      Dir.entries(SOUNDS_DIR).select{ |f| f !~ /^\./ }.map do |f|
        filename2alias f
      end
    end

    def mv from, to
      f1 = alias2filename from
      f2 = f1.sub(/\/#{from}\./, "/#{to}.")

      FileUtils.mv(f1, f2) if f1 and f2
    end

    def play name, cmd=nil
      fname = alias2filename name
      play_sound(fname, cmd) if fname
    end

    def rm *names
      names.each do |n|
        fs = alias2filename n
        if fs
          FileUtils.rm fs
        else
          puts "Warning: No sound found for '#{n}'."
        end
      end
    end

  end
end
