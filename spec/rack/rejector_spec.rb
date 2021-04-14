require 'spec_helper'
require 'rack'

describe Rack::Rejector do
  let(:app) { ->(_env) { [200, {}, %w[OK]] } }

  it 'passes the request to the block' do
    rejector =
      described_class.new(app) do |request, _options|
        expect(request).to be_an_instance_of(Rack::Request)
        false
      end

    Rack::MockRequest.new(rejector).get('some/path')
  end

  it 'does not reject if the block is false' do
    rejector = described_class.new(app) { |_request, _options| false }
    request = Rack::MockRequest.new(rejector)
    response = request.post('some/path')

    expect(response.status).to eq 200
    expect(response.body).to eq 'OK'
  end

  it 'rejects if the block is true' do
    rejector = described_class.new(app) { |_request, _options| true }
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')
    expect(response.status).to eq 503
    expect(response.body).to eq '503 SERVICE UNAVAILABLE'
  end

  it 'uses the set options if it rejects' do
    rejector =
      described_class.new(
        app,
        body: 'teapot',
        code: 418,
        headers: {
          'X-TEA-TYPE' => 'darjeeling',
        },
      ) { |_request, _options| true }
    response = Rack::MockRequest.new(rejector).get('some/path')

    expect(response.status).to eq 418
    expect(response.body).to eq 'teapot'
    expect(response.headers).to include 'X-TEA-TYPE' => 'darjeeling'
  end

  it 'allows to override the given options in the block' do
    rejector =
      described_class.new(app, body: 'teapot') do |_request, options|
        options[:body] = 'coffeepot'
      end

    response = Rack::MockRequest.new(rejector).get('some/path')

    expect(response.body).to eq 'coffeepot'
  end

  it 'does not mutate the original options' do
    original_options = { body: 'bla' }
    rejector =
      described_class.new(app, original_options) do |_request, options|
        expect(options[:body]).to eq 'bla'
        options[:body] = 'blub'
      end

    Rack::MockRequest.new(rejector).get('some/path')
    Rack::MockRequest.new(rejector).get('some/path')
  end

  it 'does not use the set options if it does not reject' do
    rejector =
      described_class.new(
        app,
        body: 'teapot',
        code: 418,
        headers: {
          'X-TEA-TYPE' => 'darjeeling',
        },
      ) { |_request, _options| false }
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')

    expect(response.status).not_to eq 418
    expect(response.body).not_to eq 'teapot'
  end
end
