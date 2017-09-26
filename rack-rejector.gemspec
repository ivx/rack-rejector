lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/rejector/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-rejector'
  spec.version       = Rack::Rejector::VERSION
  spec.authors       = ['Tristan Druyen', 'Maik Röhrig']
  spec.email         = ['tristan.druyen@invision.de',
                        'maik.roehrig@invision.de']

  spec.summary       = 'This gem is a Rack Middleware to reject requests.'
  spec.homepage      = 'https://github.com/ivx/rack-rejector'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
