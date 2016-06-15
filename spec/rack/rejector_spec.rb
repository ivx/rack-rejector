require 'spec_helper'
require 'rack'

describe Rack::Rejector do
  let(:app) { ->(_env) { [200, {}, ['OK']] } }

  it 'passes the request to the block' do
    rejector = described_class.new(app) do |request, _options|
      expect(request).to be_an_instance_of(Rack::Request)
      false
    end

    Rack::MockRequest.new(rejector).get('some/path')
  end

  it 'does not reject if the block is false' do
    rejector = described_class.new(app) do |_request, _options|
      false
    end
    request = Rack::MockRequest.new(rejector)
    response = request.post('some/path')

    expect(response.status).to eq 200
    expect(response.body).to eq 'OK'
  end

  it 'rejects if the block is true' do
    rejector = described_class.new(app) do |_request, _options|
      true
    end
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')
    expect(response.status).to eq 503
    expect(response.body).to eq '503 SERVICE UNAVAILIBLE'
  end

  it 'uses the set options if it rejects' do
    rejector = described_class.new(
      app, body: 'teapot',
           code: 418,
           headers: { 'X-TEA-TYPE' => 'darjeeling' }
    ) do |_request, _options|
      true
    end
    response = Rack::MockRequest.new(rejector).get('some/path')

    expect(response.i_m_a_teapot?).to be true # Status Code 418
    expect(response.body).to eq 'teapot'
    expect(response.headers).to include 'X-TEA-TYPE' => 'darjeeling'
  end

  it 'allows to override the given options in the block' do
    rejector = described_class.new(app, body: 'teapot') do |_request, options|
      options[:body] = 'coffeepot'
    end

    response = Rack::MockRequest.new(rejector).get('some/path')

    expect(response.body).to eq 'coffeepot'
  end

  it 'does not use the set options if it doesn\'t reject' do
    rejector = described_class.new(
      app, body: 'teapot',
           code: 418,
           headers: { 'X-TEA-TYPE' => 'darjeeling' }
    ) do |_request, _options|
      false
    end
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')

    expect(response.i_m_a_teapot?).to be false # Status Code 418
    expect(response.body).to_not eq 'teapot'
  end
end
