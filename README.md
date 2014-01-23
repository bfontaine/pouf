# pouf

[![Gem Version](https://badge.fury.io/rb/pouf.png)](http://badge.fury.io/rb/pouf)

**pouf** plays random sounds from your command-line. It started as a shell
script for a joke, but it’s now a Ruby gem.

It manages a set of sounds in a directory and use an alias for each sound, so
you can quickly play one without having to remember the filename.

Note: for now it works only on OS X.

## Install

```
gem install pouf
```

## Configure

Define the `SYS_CMD` variable in `~/.pouf/.pouf_config.rb`. It will be the
command used to play a sound.

```ruby
# ~/.pouf/.pouf_config.rb
SYS_CMD = ['cmd', 'arg1', 'arg2', ...]
```

## Usage

From the command-line:

```
$ pouf add <alias> <filename>
$ pouf rm <alias>
$ pouf mv <alias1> <alias2>
$ pouf ls
$ pouf [play] <alias>
```
