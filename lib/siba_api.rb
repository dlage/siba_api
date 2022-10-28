# frozen_string_literal: true

require_relative 'siba_api/version'
require 'savon'

# Base module for SIBA API Wrapper
module SIBAApi
  class Error < StandardError; end

  LIBNAME = 'siba_api'

  LIBDIR = File.expand_path(LIBNAME.to_s, __dir__)

  class << self
    # Alias for SIBAApi::Client.new
    #
    # @param [Hash] options
    #   the configuration options
    #
    # @return [SEFApi::Client]
    #
    # @api public
    def new(options = {}, &block)
      Client.new(options, &block)
    end

    # Default middleware stack that uses default adapter as specified
    # by configuration setup
    #
    # @return [Proc]
    #
    # @api private
    def default_middleware(options = {})
      Middleware.default(options)
    end

    # Delegate to SIBAApi::Client
    #
    # @api private
    def method_missing(method_name, *args, &block)
      if new.respond_to?(method_name)
        new.send(method_name, *args, &block)
      else
        super.respond_to_missing?
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      new.respond_to?(method_name, include_private) || super(method_name, include_private)
    end
  end
end

require_relative 'siba_api/client'
