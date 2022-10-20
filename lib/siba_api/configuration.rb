# frozen_string_literal: true

require_relative 'api/config'
require_relative 'version'

module SIBAApi
  # Stores the configuration
  class Configuration < API::Config
    property :follow_redirects, default: true

    # The value sent in the http header for 'User-Agent' if none is set
    property :user_agent, default: "SIBAApi API Ruby Gem #{SIBAApi::VERSION}"

    # By default uses the Faraday connection options if none is set
    property :connection_options, default: {}

    # Add Faraday::RackBuilder to overwrite middleware
    property :stack

    # WSDL to use for SIBA API
    property :wsdl, default: 'https://siba.sef.pt/bawsdev/boletinsalojamento.asmx?wsdl'

    # Hotel unit
    property :hotel_unit, default: '121212121'

    # API Key
    property :access_key, default: '999999999'

    # Establishment to use
    property :establishment, default: '00'

    # Hotel Unit complete information
    property :hotel_unit_info, default: {
      'Codigo_Unidade_Hoteleira' => '121212121',
      'Estabelecimento' => '00',
      'Nome' => 'Hotel teste',
      'Abreviatura' => 'teste',
      'Morada' => 'Rua da Alegria, 172',
      'Localidade' => 'Portalegre',
      'Codigo_Postal' => '1000',
      'Zona_Postal' => '234',
      'Telefone' => '214017744',
      'Fax' => '214017766',
      'Nome_Contacto' => 'Nuno teste',
      'Email_Contacto' => 'teste.teste@sef.pt'
    }
  end
end
