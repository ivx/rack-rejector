require 'rack/rejector/version'

module Rack
  class Rejector
    def initialize(app, options = {}, &block)
      default_options = {
        code: 503,
        body: '503 SERVICE UNAVAILIBLE',
        headers: {}
      }

      @app = app
      @options = default_options.merge(options)
      @block = block
    end

    def call(env)
      request = Rack::Request.new(env)
      opts = @options.clone
      reject?(request, opts) ? reject!(request, opts) : @app.call(env)
    end

    def reject?(request, opts)
      @block.call(request, opts)
    end

    def reject!(_request, opts)
      [status(opts), headers(opts), body(opts)]
    end

    def headers(opts)
      headers = {}
      headers['Content-Type'] = 'text/html; charset=utf-8'
      headers.merge(opts[:headers])
    end

    def status(opts)
      opts[:code]
    end

    def body(opts)
      Array(opts[:body])
    end
  end
end
