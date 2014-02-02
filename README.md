# pouf

[![Build Status](https://travis-ci.org/bfontaine/pouf.png)](https://travis-ci.org/bfontaine/pouf)
[![Gem Version](https://badge.fury.io/rb/pouf.png)](http://badge.fury.io/rb/pouf)
[![Coverage Status](https://coveralls.io/repos/bfontaine/pouf/badge.png)](https://coveralls.io/r/bfontaine/pouf)
[![Dependency Status](https://gemnasium.com/bfontaine/pouf.png)](https://gemnasium.com/bfontaine/pouf)

**pouf** plays random sounds from your command-line. It started as a shell
script for a joke, but it’s now a Ruby gem.

It manages a set of sounds in a directory and use an alias for each sound, so
you can quickly play one without having to remember the filename.

## Install

```
gem install pouf
```

Ubuntu/Debian users, you need to install the `mpg123` package first, or set the
`POUF_CMD` environment variable to a command which takes a filename and play a
sound from this file (default is `mpg123 -q`).

OSX users don’t need to install anything.

## Usage

From the command-line:

```
$ pouf add <alias> <filename>
$ pouf rm <alias>
$ pouf mv <alias1> <alias2>
$ pouf ls
$ pouf [play] <alias>
```

## Tests

```
$ git clone https://github.com/bfontaine/pouf.git
$ cd pouf
$ bundle install
$ bundle exec rake test
```

It’ll generate a `coverage/index.html`, which you can open in a Web browser.
