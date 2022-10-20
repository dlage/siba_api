# frozen_string_literal: true

require 'logger'
require 'base64'
require_relative 'api'

module SIBAApi
  # Main client class that implements communication with the API
  # global_params:
  # - include_related_objects: int	0-1	0
  # - page: int	positive	1
  # - per_page: int	positive	20
  class Client < API
    # SIBAApi::Client.new.calendar(38859, '2022-01-01', '2022-07-31')
    #          <sef:UnidadeHoteleira>?</sef:UnidadeHoteleira>
    #          <sef:Estabelecimento>?</sef:Estabelecimento>
    #          <!--Optional:-->
    #          <sef:ChaveAcesso>?</sef:ChaveAcesso>
    #          <!--Optional:-->
    #          <sef:Boletins>?</sef:Boletins>
    # Boletins:
    # <sef:Apelido>Apelido</sef:Apelido>
    # <sef:Nome>Teste</sef:Nome>
    # <sef:Nacionalidade>DZA</sef:Nacionalidade>
    # <sef:Data_Nascimento>2000-01-01</sef:Data_Nascimento>
    # <sef:Local_Nascimento></sef:Local_Nascimento>
    # <sef:Documento_Identificacao></sef:Documento_Identificacao>
    # <sef:Pais_Emissor_Documento></sef:Pais_Emissor_Documento>
    # <sef:Tipo_Documento></sef:Tipo_Documento>
    # <sef:Pais_Residencia_Origem></sef:Pais_Residencia_Origem>
    # <sef:Data_Entrada></sef:Data_Entrada>
    # <sef:Data_Saida></sef:Data_Saida>
    # <sef:Local_Residencia_Origem></sef:Local_Residencia_Origem>
    #
=begin
    'Apelido' => 'Surname',
    'Nome' => 'Name',
    'Nacionalidade' => 'VEN',
    'Data_Nascimento' => '19990101',
    'Local_Nascimento' => 'Place of Birth',
    'Documento_Identificacao' => '123456789',
    'Pais_Emissor_Documento' => 'YEM',
    'Tipo_Documento' => 'P',
    'Pais_Residencia_Origem' => 'ZMB',
    'Data_Entrada' => '20220801',
    'Data_Saida' => '20220831',
    'Local_Residencia_Origem' => 'Place of Residence',
=end
    def deliver_bulletins(file_number, bulletins = [], global_params = {})
      logger = Logger.new $stderr
      logger.level = Logger::DEBUG
      bulletins_xml = Gyoku.xml(
        {
          'MovimentoBAL' => {
            'Unidade_Hoteleira' => build_hotel_unit,
            'Boletim_Alojamento' => build_bulletins(bulletins),
            'Envio' => build_control_data(file_number),
            :@xmlns => 'http://sef.pt/BAws'
          },
        },
        pretty_print: true
      )
      logger.debug(bulletins_xml)
      bulletins_encoded = Base64.encode64(bulletins_xml)
      response = request(
        operation: :entrega_boletins_alojamento,
        params: {
          Boletins: bulletins_encoded
        }
      )
      process_response(response)
    end

    protected

=begin
  <Unidade_Hoteleira>
    <Codigo_Unidade_Hoteleira>121212121</Codigo_Unidade_Hoteleira>
    <Estabelecimento>00</Estabelecimento>
    <Nome>Hotel teste</Nome>
    <Abreviatura>teste</Abreviatura>
    <Morada>Rua da Alegria, 172</Morada>
    <Localidade>Portalegre</Localidade>
    <Codigo_Postal>1000</Codigo_Postal>
    <Zona_Postal>234</Zona_Postal>
    <Telefone>214017744</Telefone>
    <Fax>214017766</Fax>
    <Nome_Contacto>Nuno teste</Nome_Contacto>
    <Email_Contacto>teste.teste@sef.pt</Email_Contacto>
  </Unidade_Hoteleira>
=end
    def build_hotel_unit
      hotel_unit = {
        'Codigo_Unidade_Hoteleira' => @current_options[:hotel_unit],
        'Estabelecimento' => @current_options[:establishment],
        'Nome' => 'Hotel teste',
        'Abreviatura' => 'teste',
        'Morada' => 'Rua da Alegria, 172',
        'Localidade' => 'Portalegre',
        'Codigo_Postal' => '1000',
        'Zona_Postal' => '234',
        'Telefone' => '214017744',
        'Fax' => '214017766',
        'Nome_Contacto' => 'Nuno teste',
        'Email_Contacto' => 'teste.teste@sef.pt',
      }
      hotel_unit
    end

=begin
    <Numero_Ficheiro>97</Numero_Ficheiro>
    <Data_Movimento>2008-05-20T00:00:00</Data_Movimento>
=end
    def build_control_data(file_number)
      control_data = {
        'Numero_Ficheiro' => file_number,
        'Data_Movimento' => DateTime.now.strftime('%FT%T'),
      }
      control_data
    end

    def build_bulletins(bulletins = [])
      translation_hash = {
        surname: 'Apelido',
        name: 'Nome',
        nationality: 'Nacionalidade',
        birthdate: 'Data_Nascimento',
        place_of_birth: 'Local_Nascimento',
        id_document: 'Documento_Identificacao',
        document_country: 'Pais_Emissor_Documento',
        document_type: 'Tipo_Documento',
        start_date: 'Data_Entrada',
        end_date: 'Data_Saida',
        origin_country: 'Pais_Residencia_Origem',
        origin_place: 'Local_Residencia_Origem',
      }
      translated_bulletins = []
      bulletins.each do |b|
        bt = {}
        translation_hash.keys.each do |k|
          bt[translation_hash[k]] = b[k]
        end
        translated_bulletins.push(bt)
      end
      translated_bulletins
    end

    def process_response(response)
      result = response
      case result
      when Hash
        result.transform_keys!(&:to_sym)
        result.values.each do |r|
          process_response(r)
        end
      when Array
        result.each do |r|
          process_response(r)
        end
      end
      result
    end
  end
end
