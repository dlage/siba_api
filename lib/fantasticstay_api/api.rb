# frozen_string_literal: true

require_relative 'api_exceptions'
require_relative 'configuration'
require_relative 'constants'
require_relative 'http_status_codes'
require 'api_cache'

module FantasticstayApi
  # Core class responsible for api interface operations
  class API
    include ApiExceptions
    include Constants
    include HttpStatusCodes

    attr_reader(*FantasticstayApi.configuration.property_names, :token, :endpoint)

    attr_accessor :current_options

    # Callback to update current configuration options
    class_eval do
      FantasticstayApi.configuration.property_names.each do |key|
        define_method "#{key}=" do |arg|
          instance_variable_set("@#{key}", arg)
          current_options.merge!({ "#{key}": arg })
        end
      end
    end

    API_ENDPOINT = 'https://api.fsapp.io'
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
      opts = FantasticstayApi.configuration.fetch.merge(options)
      @current_options = opts

      FantasticstayApi.configuration.property_names.each do |key|
        send("#{key}=", opts[key])
      end
      @api_token = opts[:token] || ENV['FANTASTICSTAY_API_TOKEN']
      @api_endpoint = opts[:endpoint] || ENV['FANTASTICSTAY_API_ENDPOINT'] || API_ENDPOINT

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
      # provide your own logger
      logger = Logger.new $stderr
      logger.level = Logger::DEBUG
      @client ||= Faraday.new(@api_endpoint) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.headers['Content-Type'] = 'application/json'
        client.headers['x-api-key'] = @api_token
        client.response :logger, logger
      end
    end

    def request(http_method:, endpoint:, params: {}, cache_ttl: 3600)
      response = APICache.get(http_method.to_s + endpoint + params.to_s, cache: cache_ttl) do
         client.public_send(http_method, endpoint, params)
      end
      parsed_response = Oj.load(response.body)

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
      response.status == HTTP_OK_CODE
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
