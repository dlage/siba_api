# frozen_string_literal: true

require_relative 'api_exceptions'
require_relative 'constants'
require_relative 'http_status_codes'
require 'dry-configurable'

module SIBAApi
  # Core class responsible for api interface operations
  class API
    include ApiExceptions
    include Constants
    include HttpStatusCodes
    include Dry::Configurable

    HTTP_STATUS_MAPPING = {
      HTTP_BAD_REQUEST_CODE => BadRequestError,
      HTTP_UNAUTHORIZED_CODE => UnauthorizedError,
      HTTP_FORBIDDEN_CODE => ForbiddenError,
      HTTP_NOT_FOUND_CODE => NotFoundError,
      HTTP_UNPROCESSABLE_ENTITY_CODE => UnprocessableEntityError,
      'default' => ApiError
    }.freeze

    setting :follow_redirects, default: true

    # The value sent in the http header for 'User-Agent' if none is set
    setting :user_agent, default: "SIBAApi API Ruby Gem #{SIBAApi::VERSION}"

    # By default uses the Faraday connection options if none is set
    setting :connection_options, default: {}

    # Add Faraday::RackBuilder to overwrite middleware
    setting :stack

    # WSDL to use for SIBA API
    setting :wsdl, default: API_WSDL, reader: true

    # Hotel unit
    setting :hotel_unit, default: API_HOTEL_UNIT, reader: true

    # API Key
    setting :access_key, default: API_ACCESS_KEY, reader: true

    # Establishment to use
    setting :establishment, default: API_ESTABLISHMENT, reader: true

    # Hotel Unit complete information
    setting :hotel_unit_info, default: API_HOTEL_UNIT_INFO, reader: true

    attr_accessor :last_response

    # Create new API
    #
    # @api public
    def initialize(options = {}, &block)
      configure do |c|
        options.each_key do |key|
          c.send("#{key}=", options[key])
        end
      end

      yield_or_eval(&block) if block_given?
    end

    # Call block with argument
    #
    # @api private
    def yield_or_eval(&block)
      return unless block

      block.arity.positive? ? yield(self) : instance_eval(&block)
    end

    private

    def client
      @client ||= Savon.client do |globals|
        globals.wsdl config.wsdl
        globals.log true
        globals.log_level :debug
        globals.convert_request_keys_to :camelcase
      end
    end

    def request(operation:, params: {})
      default_params = {
        UnidadeHoteleira: config.hotel_unit,
        Estabelecimento: config.establishment,
        ChaveAcesso: config.access_key
      }

      response = client.call(operation.to_sym, message: default_params.merge(params))
      self.last_response = response

      process_operation_response(operation, response)
    end

    def process_operation_response(operation, response)
      if response_successful?(response)
        result = response.body["#{operation}_response".to_sym]["#{operation}_result".to_sym]
        return response if result == '0'
      end

      raise error_class(response.http.code), "Code: #{response.http.code}, response: #{response.body}"
    end

    def parse_response(result)
      inner_response = Nori.new(convert_tags_to: ->(tag) { tag.snakecase.to_sym }).parse(
        result
      )
      return inner_response[:erros_ba][:retorno_ba] if inner_response[:erros_ba]

      inner_response
    end

    def error_class(error_code)
      if HTTP_STATUS_MAPPING.include?(error_code)
        HTTP_STATUS_MAPPING[error_code]
      else
        HTTP_STATUS_MAPPING['default']
      end
    end

    def response_successful?(response)
      response.successful? and (response.http.code == HTTP_OK_CODE)
    end
  end
end
