# -*- coding: UTF-8 -*-

require 'fileutils'

# This module provides some tools to manage a set of sound files using
# user-friendly aliases.
module Pouf
  class << self

    # @return the default directory for sounds files
    attr_accessor :sounds_dir

    # @return the current gem's version
    def version
      '0.1.2'
    end

    # Returns a command to play a sound from a file.
    # @return [Array<String>]
    def play_cmd
      return ENV['POUF_CMD'].split(' ') if ENV['POUF_CMD']
      case RUBY_PLATFORM
      when /darwin/ then %w[afplay]
      when /linux/  then %w[mpg123 -q]
      else nil
      end
    end

    # Play a sound from a filename
    # @param filename [String]
    # @param cmd [Array<String>, NilClass]
    # @return nil
    def play_sound filename, cmd=nil
      return unless filename

      cmd ||= play_cmd

      if cmd
        system *cmd, filename
      else
        $stderr.puts 'pouf is unsupported for your platform for now'
      end
    end

    # Convert a sound alias into a filename
    # @param name [String]
    # @return [String]
    # @see Pouf.filename2alias
    def alias2filename name
      fns = Dir["#{sounds_dir}/#{name}.*"]
      fns.sort.first if fns
    end

    # Convert a filename into a sound alias
    # @param fname [String]
    # @return [String]
    # @see Pouf.alias2filename
    def filename2alias fname
      fname =~ /(?:.*?\/)*(.+)\.\w+$/
      $1
    end

    # Add a new sound.
    # @param name [String] sound alias
    # @param fname [String] filename
    # @return nil
    def add name, fname
      fname =~ /.+\.(\w+)$/
      ext = $1

      FileUtils.cp fname, "#{sounds_dir}/#{name}.#{ext}"
    end

    # Initialize the sounds directory
    # @return nil
    def init
      FileUtils.mkdir_p sounds_dir
    end

    # List the available sounds
    # @return [Array<String>]
    def list
      Dir.entries(sounds_dir).select{ |f| f !~ /^\./ }.map do |f|
        filename2alias f
      end
    end

    # Rename a sound
    # @param from [String]
    # @param to [String]
    # @return nil
    def mv from, to
      f1 = alias2filename from
      f2 = f1.sub(%r[/#{from}\.], "/#{to}.")

      FileUtils.mv(f1, f2) if f1 and f2
    end

    # Play a sound from its alias
    # @param name [String]
    # @param cmd [Array<String>, NilClass]
    # @return nil
    def play name, cmd=nil
      fname = alias2filename name
      play_sound(fname, cmd) if fname
    end

    # Remove one or more sounds
    # @param names [Array<String>] a list of sound aliases
    # @return nil
    def rm *names
      names.each do |n|
        fs = alias2filename n
        if fs
          FileUtils.rm fs
        else
          $stderr.puts "Warning: No sound found for '#{n}'."
        end
      end
    end

  end
  @sounds_dir = File.expand_path("~/.pouf/sounds")
end
