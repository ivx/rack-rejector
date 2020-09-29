lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/rejector/version'

Gem::Specification.new do |spec|
  spec.name = 'rack-rejector'
  spec.version = Rack::Rejector::VERSION
  spec.authors = ['Tristan Druyen', 'Maik Röhrig']
  spec.email = %w[tristan.druyen@invision.de maik.roehrig@invision.de]

  spec.summary = 'This gem is a Rack Middleware to reject requests.'
  spec.homepage = 'https://github.com/ivx/rack-rejector'
  spec.required_ruby_version = '~> 2.7'

  spec.files =
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  spec.require_paths = %w[lib]

  spec.add_dependency 'rack'
  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
