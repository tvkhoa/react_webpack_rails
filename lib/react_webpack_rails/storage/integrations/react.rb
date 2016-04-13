require_relative 'base_integration'
require_relative '../elements/react_component'

module ReactWebpackRails
  class Storage
    class Integrations
      class React < BaseIntegration
        def react_component(name, props, options)
          ReactWebpackRails::Storage::Elements::ReactComponent
            .new('react-component', name, props, options)
        end

        def integration_methods
          %w(react_component)
        end
      end
    end
  end
end
