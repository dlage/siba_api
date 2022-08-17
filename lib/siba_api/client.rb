# frozen_string_literal: true

require 'json'
require 'logger'
require_relative 'api'

module SIBAApi
  # Main client class that implements communication with the API
  # global_params:
  # - include_related_objects: int	0-1	0
  # - page: int	positive	1
  # - per_page: int	positive	20
  class Client < API
    def listings(global_params = {})
      response = request(
        operation: 'EntregaBoletinsAlojamento',
        params: global_params
      )
      process_response(response)
    end

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
    Apelido: 'Surname',
    Nome: 'Name',
    Nacionalidade: 'VEN',
    Data_Nascimento: '19990101',
    Local_Nascimento: 'Place of Birth',
    Documento_Identificacao: '123456789',
    Pais_Emissor_Documento: 'YEM',
    Tipo_Documento: 'P',
    Pais_Residencia_Origem: 'ZMB',
    Data_Entrada: '20220801',
    Data_Saida: '20220831',
    Local_Residencia_Origem: 'Place of Residence',
=end
    def deliver_bulletins(bulletins = [], global_params = {})
      response = request(
        operation: :entrega_boletins_alojamento,
        params: {
          Boletins: bulletins
        }.merge(global_params)
      )
      process_response(response)
    end

    def listing(listing_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: sprintf('listings/%d', listing_id),
        params: global_params
      )
      process_response(response)
    end

    # SIBAApi::Client.new.reservations(38859)
    def reservations(listing_id, filters = [], sort = nil, global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'reservations',
        params: {
          listing_id: listing_id,
          filters: filters.to_json,
          sort: sort
        }.merge!(global_params)
      )
      process_response(response)
    end

    def reservation(reservation_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: sprintf('reservations/%d', reservation_id),
        params: global_params
      )
      process_response(response)
    end

    def guest(guest_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: sprintf('guests/%d', guest_id),
        params: global_params
      )
      process_response(response)
    end

    def integrations(global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'integrations',
        params: global_params
      )
      process_response(response)
    end

    protected

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
