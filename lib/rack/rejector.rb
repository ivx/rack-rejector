require 'rack/rejector/version'

module Rack
  class Rejector
    def initialize(app, options = {}, &block)
      default_options = {
        code: 503,
        body: '503 SERVICE UNAVAILABLE',
        headers: {},
      }

      @app = app
      @options = default_options.merge(options)
      @block = block
    end

    def call(env)
      request = Rack::Request.new(env)
      options = @options.clone
      reject?(request, options) ? reject!(request, options) : @app.call(env)
    end

    private

    def reject?(request, options)
      @block.call(request, options)
    end

    def reject!(_request, options)
      [status(options), headers(options), body(options)]
    end

    def headers(options)
      headers = {}
      headers['Content-Type'] = 'text/html; charset=utf-8'
      headers.merge(options[:headers])
    end

    def status(options)
      options[:code]
    end

    def body(options)
      Array(options[:body])
    end
  end
end
