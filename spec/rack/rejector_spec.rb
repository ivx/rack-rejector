require 'spec_helper'
require 'rack'

describe Rack::Rejector do
  let(:app) { ->(_env) { [200, {}, ['OK']] } }

  it 'does not reject if the block is false' do
    rejector = described_class.new(app) do |_request, _options|
      false
    end
    request = Rack::MockRequest.new(rejector)
    response = request.post('some/path')

    expect(response.status).to eq 200
    expect(response.body).to eq 'OK'
    p response.headers
  end

  it 'rejects if the block is true' do
    rejector = described_class.new(app) do |_request, _options|
      true
    end
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')
    expect(response.status).to eq 503
    expect(response.body).to eq '503 SERVICE UNAVAILIBLE'
    p response.headers
  end

  it 'uses the set options if it rejects' do
    rejector = described_class.new(app) do |_request, options|
      options[:body] = 'teapot'
      options[:code] = 418
      options[:headers] = { X_TEST_HEADER: 'darjeeling' }
      true
    end
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')

    expect(response.i_m_a_teapot?).to be true # Status Code 418
    expect(response.body).to eq 'teapot'
    expect(response.headers).to include X_TEST_HEADER: 'darjeeling'
  end

  it 'does not use the set options if it doesn\'t reject' do
    rejector = described_class.new(app) do |_request, options|
      options[:body] = 'teapot'
      options[:code] = 418
      false
    end
    request = Rack::MockRequest.new(rejector)
    response = request.get('some/path')

    expect(response.i_m_a_teapot?).to be false # Status Code 418
    expect(response.body).to_not eq 'teapot'
  end
end
