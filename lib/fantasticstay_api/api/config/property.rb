# frozen_string_literal: true

module FantasticstayApi
  class API
    class Config
      # Property objects provide an interface for configuration options
      class Property
        attr_reader :name, :default, :required

        def initialize(name, options)
          @name = name
          @default = options.fetch(:default, nil)
          @required = options.fetch(:required, nil)
          @options = options
        end

        # @api private
        def define_accessor_methods(properties)
          properties.define_reader_method(self, name, :public)
          properties.define_writer_method(self, "#{name}=", :public)
        end
      end
    end
  end
end
