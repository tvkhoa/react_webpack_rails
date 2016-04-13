require_relative 'storage/integrations/react_router'
require_relative 'storage/integrations/react'

module ReactWebpackRails
  class Storage
    def initialize(integrations = [])
      @integrations = ['ReactRouter', 'React'] + integrations
      @integrations = @integrations.map do |name|
        "#{self.class}::Integrations::#{name}".constantize.new
      end
      @registered_methods = @integrations.flat_map { |i| i.integration_methods }
      @array ||= []
    end

    def elements
      @array
    end

    def clear
      @array = []
    end

    def method_missing(method, *arguments, &block)
      super unless method.to_s.in? @registered_methods
      component = nil
      @integrations.each do |integration|
        component = integration.integration_method(method, *arguments, &block)
        break if component.present?
      end
      @array << component
      component
    end

    private

    def serialize_props(raw_props)
      props = raw_props.as_json
      return props unless Rails.application.config.react.camelize_props
      ReactWebpackRails::Services::CamelizeKeys.call(props)
    end
  end
end
