# coding: utf-8
require File.expand_path('../lib/xmpp2s/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'xmpp2s'
  spec.version       = Xmpp2s::VERSION
  spec.authors       = ['David Herman', 'Jan Strnadek']
  spec.email         = ['sordson@gmail.com', 'jan.strnadek@gmail.com']
  spec.summary       = 'Gem for sending messages over xmpp protocol.'
  spec.homepage      = 'https://github.com/ChattyCrow/xmpp2s'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'libxml-ruby', '~> 2.8.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rdoc'
  spec.add_dependency 'byebug'
end
