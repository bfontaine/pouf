require './lib/pouf'

Gem::Specification.new do |s|
    s.name          = 'pouf'
    s.version       = Pouf.version
    s.date          = Time.now

    s.summary       = 'Play random sounds from the command-line'
    s.description   = 'Quickly play random short sounds from the command-line'
    s.license       = 'MIT'

    s.author        = 'Baptiste Fontaine'
    s.email         = 'batifon@yahoo.fr'
    s.homepage      = 'https://github.com/bfontaine/pouf'

    s.files         = Dir['lib/*.rb']
    s.require_path  = 'lib'
    s.executables  << 'pouf'

    s.add_development_dependency 'simplecov'
    s.add_development_dependency 'rake'
    s.add_development_dependency 'test-unit'
    s.add_development_dependency 'coveralls'
end
