# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasticstayApi do
  it 'has a version number' do
    expect(FantasticstayApi::VERSION).not_to be nil
  end

  describe 'FantasticstayApi::Client' do
    api_key = 'test_key'
    api_endpoint = 'https://api.fsapp.io'
    let(:api_client) { FantasticstayApi.new({ token: api_key, endpoint: api_endpoint }) }
    it 'is initialized with options' do
      expect(api_client).to be_a(FantasticstayApi::Client)
      expect(api_client.token).to equal(api_key)
      expect(api_client.endpoint).to equal(api_endpoint)
    end
    let(:default_api_client) { FantasticstayApi.new({ token: api_key, endpoint: api_endpoint }) }
    it 'defaults are initialized as well' do
      expect(api_client).to be_a(FantasticstayApi::Client)
      expect(api_client.token).not_to be_nil
      expect(api_client.endpoint).not_to be_nil
    end
  end

  describe 'listings' do
    let(:request_path) { '/listings' }
    let(:body) { fixture('listings.json') }
    let(:status) { 200 }

    before do
      stub_get(request_path).to_return(body: body, status: status)
    end

    let(:listings_response) { FantasticstayApi::Client.new.listings }
    it 'returns correctly some data', :vcr do
      expect(listings_response).to be_kind_of(Hash)
      expect(listings_response).to have_key(:total)
      expect(listings_response).to have_key(:listings)
      expect(listings_response[:listings]).to be_kind_of(Array)
    end
    it 'each listing has basic information', :vcr do
      listings_response[:listings].each do |l|
        expect(l).to have_key(:id)
        expect(l).to have_key(:channel_listing_id)
        expect(l).to have_key(:listing_type)
        expect(l).to have_key(:name)
        expect(l).to have_key(:lat)
        expect(l).to have_key(:lng)
      end
    end
  end

  describe 'integrations' do
    let(:request_path) { '/integrations' }
    let(:body) { fixture('integrations.json') }
    let(:status) { 200 }

    before do
      stub_get(request_path).to_return(body: body, status: status)
    end

    let(:integrations_result) { FantasticstayApi::Client.new.integrations }
    it 'returns integrations', :vcr do
      puts integrations_result
      expect(integrations_result).to have_key(:total)
      expect(integrations_result).to have_key(:integrations)
      integrations_result[:integrations].each do |i|
        expect(i).to have_key(:id)
        expect(i).to have_key(:nickname)
        expect(i).to have_key(:picture)
        expect(i).to have_key(:user)
        expect(i).to have_key(:full_name)
      end
    end
  end
end
