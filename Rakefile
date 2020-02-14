require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

task default: %i[spec rubocop]

task :version do
  puts Gem::Specification.load('auth-ruby.gemspec').version
end

module Bundler
  class GemHelper
    def install
      desc "Build #{name}-#{version}.gem into the pkg directory."
      task 'build' do
        build_gem
      end

      GemHelper.instance = self
    end
  end
end

Bundler::GemHelper.install_tasks
