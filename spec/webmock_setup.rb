# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |config|
  MOCK_BODY_PER_REQUEST = {
    # '/listings' => File.new(File.join(File.expand_path('fixtures', __dir__), '/', 'listings.json')),
    '/listings' => fixture('listings.json')
    # '/integrations' => fixture('integrations.json')
  }.freeze

  config.before(:each) do
    MOCK_BODY_PER_REQUEST.each_pair do |path, body|
      stub_request(:get, "https://api.fsapp.io#{path}")
        .to_return(status: 200, body: body)
    end
  end

  # ....
end
