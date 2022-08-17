# frozen_string_literal: true

require_relative 'api_exceptions'
require_relative 'configuration'
require_relative 'constants'
require_relative 'http_status_codes'

module SIBAApi
  # Core class responsible for api interface operations
  class API
    include ApiExceptions
    include Constants
    include HttpStatusCodes

    attr_reader(*SIBAApi.configuration.property_names, :wsdl, :hotel_unit, :access_key, :establishment)

    attr_accessor :current_options

    # Callback to update current configuration options
    class_eval do
      SIBAApi.configuration.property_names.each do |key|
        define_method "#{key}=" do |arg|
          instance_variable_set("@#{key}", arg)
          current_options.merge!({ "#{key}": arg })
        end
      end
    end

    API_WSDL = 'https://siba.sef.pt/bawsdev/boletinsalojamento.asmx?wsdl'
    HTTP_STATUS_MAPPING = {
      HTTP_BAD_REQUEST_CODE => BadRequestError,
      HTTP_UNAUTHORIZED_CODE => UnauthorizedError,
      HTTP_FORBIDDEN_CODE => ForbiddenError,
      HTTP_NOT_FOUND_CODE => NotFoundError,
      HTTP_UNPROCESSABLE_ENTITY_CODE => UnprocessableEntityError,
      'default' => ApiError
    }.freeze

    # Create new API
    #
    # @api public
    def initialize(options = {}, &block)
      opts = SIBAApi.configuration.fetch.merge(options)
      @current_options = opts

      SIBAApi.configuration.property_names.each do |key|
        send("#{key}=", opts[key])
      end
      @wsdl = opts[:wsdl] || ENV['SIBA_API_WSDL'] || API_WSDL

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
        globals.wsdl @wsdl
        globals.log true
        globals.log_level :debug
        globals.convert_request_keys_to :camelcase
      end
    end

    def request(operation:, params: {}, cache_ttl: 3600)
      default_params = {
        UnidadeHoteleira: @current_options[:hotel_unit],
        Estabelecimento: @current_options[:establishment],
        ChaveAcesso: @current_options[:access_key]
      }
      #response = APICache.get(operation.to_s + params.to_s, cache: cache_ttl) do
      response = client.call(operation.to_sym, message: default_params.merge(params))
      #end
      return response
      parsed_response = response.body

      return parsed_response if response_successful?(response)

      raise error_class(response), "Code: #{response.status}, response: #{response.body}"
    end

    def error_class(response)
      if HTTP_STATUS_MAPPING.include?(response.status)
        HTTP_STATUS_MAPPING[response.status]
      else
        HTTP_STATUS_MAPPING['default']
      end
    end

    def response_successful?(response)
      response.successful? and (response.http.code == HTTP_OK_CODE)
    end

    # Responds to attribute query or attribute clear
    #
    # @api private
    def method_missing(method_name, *args, &block)
      # :nodoc:
      case method_name.to_s
      when /^(.*)\?$/
        !!send(Regexp.last_match(1).to_s)
      when /^clear_(.*)$/
        send("#{Regexp.last_match(1)}=", nil)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.start_with?('clear_') || super
    end
  end
end
