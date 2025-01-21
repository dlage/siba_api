# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SIBAApi do
  it 'has a version number' do
    expect(SIBAApi::VERSION).not_to be nil
  end

  describe 'SIBAApi::Client' do
    wsdl = 'https://siba.ssi.gov.pt/bawsdev/boletinsalojamento.asmx?wsdl'
    hotel_unit = '121212121'
    establishment = '00'
    access_key = '999999999'

    let(:api_client) do
      SIBAApi.new(
        wsdl: wsdl,
        hotel_unit: hotel_unit,
        establishment: establishment,
        access_key: access_key
      )
    end
    it 'is initialized with options' do
      expect(api_client).to be_a(SIBAApi::Client)
      expect(api_client.wsdl).to equal(wsdl)
      expect(api_client.hotel_unit).to equal(hotel_unit)
      expect(api_client.establishment).to equal(establishment)
      expect(api_client.access_key).to equal(access_key)
    end

    let(:api_client) { SIBAApi.new }
    it 'Default options is initialized with same values' do
      expect(api_client).to be_a(SIBAApi::Client)
      expect(api_client.wsdl).to equal(wsdl)
      expect(api_client.hotel_unit).to equal(hotel_unit)
      expect(api_client.establishment).to equal(establishment)
      expect(api_client.access_key).to equal(access_key)
    end

    person = {
      surname: 'Surname', name: 'Name', nationality: 'VEN', birthdate: '1999-01-01T00:00:00',
      place_of_birth: 'Place of Birth', id_document: '123456789', document_country: 'YEM',
      document_type: 'P', origin_country: 'USA', start_date: '2022-08-01T00:00:00',
      end_date: '2022-08-31T00:00:00', origin_place: 'Place of Residence'
    }

    let(:response) do
      VCR.use_cassette('deliver_bulletins_success') do
        api_client.deliver_bulletins(
          123,
          [person]
        )
      end
    end
    it 'builds the request for one person entry correctly' do
      expect(response).to be_kind_of(Savon::Response)
      expect(response.successful?).to eq(true)
      expect(response.body).to be_kind_of(Hash)
    end

    let(:response) do
      VCR.use_cassette('deliver_bulletins_multiple_success') do
        api_client.deliver_bulletins(
          123,
          [person, person, person]
        )
      end
    end
    it 'builds the request for multiple people correctly' do
      expect(response).to be_kind_of(Savon::Response)
      expect(response.successful?).to eq(true)
      expect(response.body).to be_kind_of(Hash)
    end
  end
end
