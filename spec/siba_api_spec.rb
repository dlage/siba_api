# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SIBAApi do
  it 'has a version number' do
    expect(SIBAApi::VERSION).not_to be nil
  end

  describe 'SIBAApi::Client' do
    wsdl = 'https://siba.sef.pt/bawsdev/boletinsalojamento.asmx?wsdl'
    hotel_unit = '121212121'
    establishment = '00'
    access_key = '999999999'

    let(:api_client) { SIBAApi.new(wsdl: wsdl, hotel_unit: hotel_unit, establishment: establishment, access_key: access_key) }
    it 'is initialized with options' do
      expect(api_client).to be_a(SIBAApi::Client)
      expect(api_client.wsdl).to equal(wsdl)
      expect(api_client.hotel_unit).to equal(hotel_unit)
      expect(api_client.establishment).to equal(establishment)
      expect(api_client.access_key).to equal(access_key)
    end

    let(:response) {
      api_client.deliver_bulletins(123, [{ surname: 'Surname', name: 'Name', nationality: 'VEN', birthdate: '1999-01-01T00:00:00', place_of_birth: 'Place of Birth', id_document: '123456789', document_country: 'YEM', document_type: 'P', origin_country: 'USA', start_date: '2022-08-01T00:00:00', end_date: '2022-08-31T00:00:00', origin_place: 'Place of Residence', }])
    }
    it 'calls implemented method for the api' do
      expect(response).to be_kind_of(Savon::Response)
    end
  end

  describe 'deliver_bulletins' do

    let(:listings_response) { SIBAApi::Client.new.listings }
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

    let(:integrations_result) { SIBAApi::Client.new.integrations }
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
