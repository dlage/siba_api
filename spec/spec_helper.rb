# frozen_string_literal: true

require 'dotenv/load'
require 'siba_api'
require 'webmock/rspec'
# require 'vcr_setup'
# require 'webmock_setup'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def stub_get(path, endpoint = SIBAApi.endpoint.to_s)
  stub_request(:get, endpoint + path)
end

def stub_post(path, endpoint = SIBAApi.endpoint.to_s)
  stub_request(:post, endpoint + path)
end

def stub_patch(path, endpoint = SIBAApi.endpoint.to_s)
  stub_request(:patch, endpoint + path)
end

def stub_put(path, endpoint = SIBAApi.endpoint.to_s)
  stub_request(:put, endpoint + path)
end

def stub_delete(path, endpoint = SIBAApi.endpoint.to_s)
  stub_request(:delete, endpoint + path)
end

def a_get(path, endpoint = SIBAApi.endpoint.to_s)
  a_request(:get, endpoint + path)
end

def a_post(path, endpoint = SIBAApi.endpoint.to_s)
  a_request(:post, endpoint + path)
end

def a_patch(path, endpoint = SIBAApi.endpoint.to_s)
  a_request(:patch, endpoint + path)
end

def a_put(path, endpoint = SIBAApi.endpoint)
  a_request(:put, endpoint + path)
end

def a_delete(path, endpoint = SIBAApi.endpoint)
  a_request(:delete, endpoint + path)
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new(File.join(fixture_path, '/', file))
end
